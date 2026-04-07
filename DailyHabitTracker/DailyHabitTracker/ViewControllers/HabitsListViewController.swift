//
//  HabitsListViewController.swift
//  DailyHabitTracker
//
//  Created by Jose Ramos on 6/4/26.
//

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addHabit)
        )
        navigationItem.leftBarButtonItem = editButtonItem
        configureTableView()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
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

    @objc private func addHabit() {
        presentHabitForm(title: "Nuevo habito", habit: nil, index: nil)
    }

    private func presentHabitForm(title: String, habit: Habit?, index: Int?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Titulo"
            textField.text = habit?.title
        }
        alert.addTextField { textField in
            textField.placeholder = "Detalle"
            textField.text = habit?.detail
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let titleText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let detailText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !titleText.isEmpty else { return }

            if let index = index {
                self.viewModel.updateHabit(at: index, title: titleText, detail: detailText)
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                let habit = self.viewModel.addHabit(title: titleText, detail: detailText)
                if let newIndex = self.viewModel.habits.firstIndex(where: { $0.id == habit.id }) {
                    let indexPath = IndexPath(row: newIndex, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                } else {
                    self.tableView.reloadData()
                }
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.deleteHabit(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completion in
            self?.viewModel.deleteHabit(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completion in
            guard let self = self else { return }
            let habit = self.viewModel.habit(at: indexPath.row)
            self.presentHabitForm(title: "Editar habito", habit: habit, index: indexPath.row)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
