//
//  TaskSummaryViewController.swift
//  ToDoList
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class TaskSummaryViewController: UIViewController {
    private let viewModel: TaskSummaryViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: TaskSummaryViewModel = TaskSummaryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resumen"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTasksChanged), name: TaskNotifications.tasksDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTasksChanged), name: TaskNotifications.taskExpiryDidChange, object: nil)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: TaskNotifications.tasksDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: TaskNotifications.taskExpiryDidChange, object: nil)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleTasksChanged() {
        tableView.reloadData()
    }
}

extension TaskSummaryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return viewModel.prioritySummary().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let summary = viewModel.summary()

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Total"
                cell.detailTextLabel?.text = String(summary.total)
            case 1:
                cell.textLabel?.text = "Completadas"
                cell.detailTextLabel?.text = String(summary.completed)
            default:
                cell.textLabel?.text = "Vencidas"
                cell.detailTextLabel?.text = String(summary.expired)
                cell.detailTextLabel?.textColor = summary.expired > 0 ? .systemRed : .secondaryLabel
            }
            return cell
        }

        let item = viewModel.prioritySummary()[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = String(item.count)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Resumen"
        }
        return "Por prioridad"
    }
}

extension TaskSummaryViewController: UITableViewDelegate {}
