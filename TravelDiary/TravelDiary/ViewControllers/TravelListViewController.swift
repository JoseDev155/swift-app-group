//
//  TravelListViewController.swift
//  TravelDiary
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class TravelListViewController: UIViewController {
    private let viewModel: TravelListViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var expandedIds: Set<String> = []

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    init(viewModel: TravelListViewModel = TravelListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Viajes"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntry))
        navigationItem.leftBarButtonItem = editButtonItem
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEntriesChanged), name: TravelNotifications.entriesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEntriesChanged), name: TravelNotifications.preferencesDidChange, object: nil)
        handleEntriesChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: TravelNotifications.entriesDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: TravelNotifications.preferencesDidChange, object: nil)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TravelEntryCell.self, forCellReuseIdentifier: TravelEntryCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 96

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleEntriesChanged() {
        tableView.reloadData()
    }

    @objc private func addEntry() {
        presentEntryForm(title: "Nuevo viaje", entry: nil, index: nil)
    }

    private func presentEntryForm(title: String, entry: TravelEntry?, index: Int?) {
        let alert = UIAlertController(title: title, message: "Fecha: yyyy-MM-dd", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Pais"
            textField.text = entry?.country
        }
        alert.addTextField { textField in
            textField.placeholder = "Ciudad"
            textField.text = entry?.city
        }
        alert.addTextField { textField in
            textField.placeholder = "Notas"
            textField.text = entry?.notes
        }
        alert.addTextField { textField in
            textField.placeholder = "Fecha"
            textField.text = entry.map { self.dateFormatter.string(from: $0.date) }
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let countryText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let cityText = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let notesText = alert.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let dateText = alert.textFields?[3].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard !countryText.isEmpty else {
                self.presentValidationAlert(message: "El pais es obligatorio.")
                return
            }

            guard let date = self.dateFormatter.date(from: dateText) else {
                self.presentValidationAlert(message: "Fecha invalida. Usa yyyy-MM-dd.")
                return
            }

            if let index = index {
                self.viewModel.updateEntry(at: index, country: countryText, city: cityText, notes: notesText, date: date)
            } else {
                self.viewModel.addEntry(country: countryText, city: cityText, notes: notesText, date: date)
            }

            self.tableView.reloadData()
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func confirmDelete(at indexPath: IndexPath) {
        let entry = viewModel.entry(at: indexPath.row)
        let alert = UIAlertController(
            title: "Eliminar viaje",
            message: "Deseas eliminar \"\(entry.country)\"?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteEntry(at: indexPath.row)
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

extension TravelListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TravelEntryCell.reuseIdentifier, for: indexPath) as? TravelEntryCell else {
            return UITableViewCell()
        }
        let entry = viewModel.entry(at: indexPath.row)
        let isExpanded = expandedIds.contains(entry.id)
        cell.configure(with: entry, expanded: isExpanded, formatter: dateFormatter)
        return cell
    }
}

extension TravelListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let entry = viewModel.entry(at: indexPath.row)

        if expandedIds.contains(entry.id) {
            expandedIds.remove(entry.id)
        } else {
            expandedIds.insert(entry.id)
        }

        if let cell = tableView.cellForRow(at: indexPath) as? TravelEntryCell {
            let expanded = expandedIds.contains(entry.id)
            cell.setExpanded(expanded, animated: true)
        }

        tableView.beginUpdates()
        tableView.endUpdates()
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
            let entry = self.viewModel.entry(at: indexPath.row)
            self.presentEntryForm(title: "Editar viaje", entry: entry, index: indexPath.row)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
