import UIKit

final class TaskListViewController: UIViewController {
    private let viewModel: TaskListViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var expiryTimer: Timer?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    init(viewModel: TaskListViewModel = TaskListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tareas"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.leftBarButtonItem = editButtonItem
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTasksChanged), name: TaskNotifications.tasksDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTasksChanged), name: TaskNotifications.taskExpiryDidChange, object: nil)
        startExpiryTimer()
        handleTasksChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: TaskNotifications.tasksDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: TaskNotifications.taskExpiryDidChange, object: nil)
        stopExpiryTimer()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleTasksChanged() {
        viewModel.refreshExpiredTasks(currentDate: Date())
        tableView.reloadData()
    }

    private func startExpiryTimer() {
        stopExpiryTimer()
        expiryTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.viewModel.refreshExpiredTasks(currentDate: Date())
            self?.tableView.reloadData()
        }
    }

    private func stopExpiryTimer() {
        expiryTimer?.invalidate()
        expiryTimer = nil
    }

    @objc private func addTask() {
        presentTaskForm(title: "Nueva tarea", task: nil, index: nil)
    }

    private func presentTaskForm(title: String, task: TaskItem?, index: Int?) {
        let alert = UIAlertController(title: title, message: "Formato de fecha: yyyy-MM-dd HH:mm", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Titulo"
            textField.text = task?.title
        }
        alert.addTextField { textField in
            textField.placeholder = "Detalle"
            textField.text = task?.detail
        }
        alert.addTextField { textField in
            textField.placeholder = "Fecha limite"
            textField.text = task.map { self.dateFormatter.string(from: $0.dueDate) }
        }
        alert.addTextField { textField in
            textField.placeholder = "Prioridad (Alta/Media/Baja)"
            textField.text = task?.priority.title
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let titleText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let detailText = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let dateText = alert.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let priorityText = alert.textFields?[3].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard !titleText.isEmpty else {
                self.presentValidationAlert(message: "El titulo es obligatorio.")
                return
            }

            guard let dueDate = self.dateFormatter.date(from: dateText) else {
                self.presentValidationAlert(message: "Fecha invalida. Usa yyyy-MM-dd HH:mm.")
                return
            }

            guard let priority = self.priority(from: priorityText) else {
                self.presentValidationAlert(message: "Prioridad invalida. Usa Alta, Media o Baja.")
                return
            }

            if let index = index {
                self.viewModel.updateTask(at: index, title: titleText, detail: detailText, priority: priority, dueDate: dueDate)
            } else {
                self.viewModel.addTask(title: titleText, detail: detailText, priority: priority, dueDate: dueDate)
            }

            self.tableView.reloadData()
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func priority(from value: String) -> TaskPriority? {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "alta":
            return .high
        case "media":
            return .medium
        case "baja":
            return .low
        default:
            return nil
        }
    }

    private func confirmDelete(at indexPath: IndexPath) {
        let task = viewModel.task(at: indexPath.row)
        let alert = UIAlertController(
            title: "Eliminar tarea",
            message: "Deseas eliminar \"\(task.title)\"?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteTask(at: indexPath.row)
            self?.tableView.reloadData()
        })
        present(alert, animated: true)
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos invalidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = viewModel.task(at: indexPath.row)
        cell.configure(with: task, formatter: dateFormatter)
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.toggleCompletion(at: indexPath.row)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        confirmDelete(at: indexPath)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completion in
            self?.confirmDelete(at: indexPath)
            completion(true)
        }

        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completion in
            guard let self = self else { return }
            let task = self.viewModel.task(at: indexPath.row)
            self.presentTaskForm(title: "Editar tarea", task: task, index: indexPath.row)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
