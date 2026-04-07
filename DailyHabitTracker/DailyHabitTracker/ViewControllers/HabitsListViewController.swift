import UIKit

final class HabitsListViewController: UIViewController {
    private let viewModel: HabitsListViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: HabitsListViewModel = HabitsListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Habitos"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureTableView()
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HabitCell.self, forCellReuseIdentifier: HabitCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HabitsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.reuseIdentifier, for: indexPath) as? HabitCell else {
            return UITableViewCell()
        }

        let habit = viewModel.habit(at: indexPath.row)
        let completed = viewModel.isCompleted(at: indexPath.row)
        cell.configure(with: habit, completed: completed, animated: false)
        return cell
    }
}

extension HabitsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completed = viewModel.toggleCompletion(at: indexPath.row)

        if let cell = tableView.cellForRow(at: indexPath) as? HabitCell {
            let habit = viewModel.habit(at: indexPath.row)
            cell.configure(with: habit, completed: completed, animated: true)
        }
    }
}
