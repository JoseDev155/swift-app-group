//
//  SessionsViewController.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class SessionsViewController: UIViewController {
    private let viewModel: SessionsViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: SessionsViewModel = SessionsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sesiones"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSession))
        navigationItem.leftBarButtonItem = editButtonItem
        configureTableView()
        updateEmptyState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionsChanged), name: PomodoroNotifications.sessionsDidChange, object: nil)
        handleSessionsChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: PomodoroNotifications.sessionsDidChange, object: nil)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SessionCell.self, forCellReuseIdentifier: SessionCell.reuseIdentifier)
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

    private func updateEmptyState() {
        if viewModel.sessions.isEmpty {
            let label = UILabel()
            label.text = "Sin sesiones registradas."
            label.textColor = .secondaryLabel
            label.font = .preferredFont(forTextStyle: .body)
            label.textAlignment = .center
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }

    @objc private func handleSessionsChanged() {
        tableView.reloadData()
        updateEmptyState()
    }

    @objc private func addSession() {
        presentSessionForm(context: .new)
    }

    private func presentSessionForm(context: EntryContext<PomodoroSession>) {
        let title: String
        let session: PomodoroSession?

        switch context {
        case .new:
            title = "Nueva sesión"
            session = nil
        case .edit(let current):
            title = "Editar sesión"
            session = current
        }

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Modo (Trabajo, Descanso corto, Descanso largo)"
            textField.text = session?.mode.title
        }
        alert.addTextField { textField in
            textField.placeholder = "Duración (minutos)"
            textField.keyboardType = .numberPad
            if let session = session {
                textField.text = "\(session.durationMinutes)"
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Nota (opcional)"
            textField.text = session?.note
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let modeText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let durationText = alert.textFields?.dropFirst().first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let noteText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard let mode = PomodoroMode.fromInput(modeText) else {
                self.presentValidationAlert(message: "Ingresa un modo válido.")
                return
            }

            guard let minutes = Int(durationText), minutes > 0 else {
                self.presentValidationAlert(message: "Ingresa una duración válida.")
                return
            }

            if let session = session {
                self.viewModel.updateSession(id: session.id, mode: mode, durationMinutes: minutes, note: noteText)
            } else {
                self.viewModel.addSession(mode: mode, durationMinutes: minutes, note: noteText)
            }
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func confirmDelete(at indexPath: IndexPath) {
        let session = viewModel.session(at: indexPath.row)
        let alert = UIAlertController(title: "Eliminar sesión", message: "Deseas eliminar esta sesión?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteSession(id: session.id)
        })
        present(alert, animated: true)
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos inválidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}

extension SessionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sessions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.reuseIdentifier, for: indexPath) as? SessionCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.session(at: indexPath.row))
        return cell
    }
}

extension SessionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
            let session = self.viewModel.session(at: indexPath.row)
            self.presentSessionForm(context: .edit(session))
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
