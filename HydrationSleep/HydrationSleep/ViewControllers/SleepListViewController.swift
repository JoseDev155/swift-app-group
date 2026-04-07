//
//  SleepListViewController.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class SleepListViewController: UIViewController {
    private let viewModel: SleepListViewModel
    private let summaryView = SummaryCardView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: SleepListViewModel = SleepListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sueno"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntry))
        navigationItem.leftBarButtonItem = editButtonItem
        configureLayout()
        configureTableView()
        updateSummary()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: HydrationSleepNotifications.sleepDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: HydrationSleepNotifications.settingsDidChange, object: nil)
        handleDataChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: HydrationSleepNotifications.sleepDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: HydrationSleepNotifications.settingsDidChange, object: nil)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    private func configureLayout() {
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(summaryView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryView.heightAnchor.constraint(equalToConstant: 140),

            tableView.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SleepEntryCell.self, forCellReuseIdentifier: SleepEntryCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
    }

    private func updateSummary() {
        let total = viewModel.todayTotal
        let goal = max(viewModel.sleepGoal, 0.1)
        let totalText = String(format: "%.1f", total)
        let goalText = String(format: "%.1f", goal)
        let subtitle = "Meta diaria: \(goalText) h"
        summaryView.configure(title: "Sueno de hoy", value: "\(totalText) h", subtitle: subtitle, progress: viewModel.progress)
    }

    @objc private func handleDataChanged() {
        updateSummary()
        tableView.reloadData()
    }

    @objc private func addEntry() {
        presentSleepForm(context: .new)
    }

    private func presentSleepForm(context: EntryContext<SleepEntry>) {
        let title: String
        let entry: SleepEntry?

        switch context {
        case .new:
            title = "Nuevo sueno"
            entry = nil
        case .edit(let current):
            title = "Editar sueno"
            entry = current
        }

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Horas dormidas (ej. 7.5)"
            textField.keyboardType = .decimalPad
            if let entry = entry {
                textField.text = String(format: "%.1f", entry.hours)
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Calidad: Baja, Media o Alta"
            textField.text = entry?.quality.title
        }
        alert.addTextField { textField in
            textField.placeholder = "Nota (opcional)"
            textField.text = entry?.note
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let hoursText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let qualityText = alert.textFields?.dropFirst().first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let noteText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let normalizedHours = hoursText.replacingOccurrences(of: ",", with: ".")

            guard let hours = Double(normalizedHours), hours > 0 else {
                self.presentValidationAlert(message: "Ingresa horas validas para el sueno.")
                return
            }

            guard let quality = SleepQuality.fromInput(qualityText) else {
                self.presentValidationAlert(message: "Selecciona una calidad valida: Baja, Media o Alta.")
                return
            }

            if let entry = entry {
                self.viewModel.updateEntry(id: entry.id, hours: hours, quality: quality, note: noteText)
            } else {
                self.viewModel.addEntry(hours: hours, quality: quality, note: noteText)
            }
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func confirmDelete(entry: SleepEntry) {
        let alert = UIAlertController(
            title: "Eliminar registro",
            message: "Deseas eliminar este registro de sueno?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteEntry(id: entry.id)
        })
        present(alert, animated: true)
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos invalidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}

extension SleepListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SleepEntryCell.reuseIdentifier, for: indexPath) as? SleepEntryCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.entry(at: indexPath.row))
        return cell
    }
}

extension SleepListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        confirmDelete(entry: viewModel.entry(at: indexPath.row))
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completion in
            guard let self = self else { return }
            self.confirmDelete(entry: self.viewModel.entry(at: indexPath.row))
            completion(true)
        }

        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completion in
            guard let self = self else { return }
            let entry = self.viewModel.entry(at: indexPath.row)
            self.presentSleepForm(context: .edit(entry))
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
