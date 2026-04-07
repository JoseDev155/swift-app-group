//
//  InventoryListViewController.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class InventoryListViewController: UIViewController {
    private let viewModel: InventoryListViewModel
    private let summaryView = InventorySummaryView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: InventoryListViewModel = InventoryListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inventario"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = editButtonItem
        configureLayout()
        configureTableView()
        updateSummary()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: InventoryNotifications.inventoryDidChange, object: nil)
        handleDataChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: InventoryNotifications.inventoryDidChange, object: nil)
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
            summaryView.heightAnchor.constraint(equalToConstant: 110),

            tableView.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(InventoryItemCell.self, forCellReuseIdentifier: InventoryItemCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    private func updateSummary() {
        summaryView.configure(total: viewModel.totalCount, lowStock: viewModel.lowStockCount)
    }

    @objc private func handleDataChanged() {
        updateSummary()
        tableView.reloadData()
    }

    @objc private func addItem() {
        presentItemForm(context: .new)
    }

    private func presentItemForm(context: EntryContext<InventoryItem>) {
        let title: String
        let item: InventoryItem?

        switch context {
        case .new:
            title = "Nuevo producto"
            item = nil
        case .edit(let current):
            title = "Editar producto"
            item = current
        }

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Nombre"
            textField.text = item?.name
        }
        alert.addTextField { textField in
            textField.placeholder = "Pasillo"
            textField.text = item?.aisle
        }
        alert.addTextField { textField in
            textField.placeholder = "Sección"
            textField.text = item?.section
        }
        alert.addTextField { textField in
            textField.placeholder = "Stock actual"
            textField.keyboardType = .numberPad
            if let item = item {
                textField.text = "\(item.stock)"
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Stock mínimo"
            textField.keyboardType = .numberPad
            if let item = item {
                textField.text = "\(item.minStock)"
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Nota (opcional)"
            textField.text = item?.note
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let nameText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let aisleText = alert.textFields?.dropFirst().first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sectionText = alert.textFields?.dropFirst(2).first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let stockText = alert.textFields?.dropFirst(3).first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let minStockText = alert.textFields?.dropFirst(4).first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let noteText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard !nameText.isEmpty else {
                self.presentValidationAlert(message: "Ingresa un nombre válido.")
                return
            }

            guard !aisleText.isEmpty else {
                self.presentValidationAlert(message: "Ingresa un pasillo válido.")
                return
            }

            guard !sectionText.isEmpty else {
                self.presentValidationAlert(message: "Ingresa una sección válida.")
                return
            }

            guard let stock = Int(stockText), stock >= 0 else {
                self.presentValidationAlert(message: "Ingresa un stock válido.")
                return
            }

            guard let minStock = Int(minStockText), minStock >= 0 else {
                self.presentValidationAlert(message: "Ingresa un mínimo válido.")
                return
            }

            if let item = item {
                self.viewModel.updateItem(id: item.id, name: nameText, aisle: aisleText, section: sectionText, stock: stock, minStock: minStock, note: noteText)
            } else {
                self.viewModel.addItem(name: nameText, aisle: aisleText, section: sectionText, stock: stock, minStock: minStock, note: noteText)
            }
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func confirmDelete(at indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath.row)
        let alert = UIAlertController(
            title: "Eliminar producto",
            message: "Deseas eliminar \"\(item.name)\"?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.animateDeletion(at: indexPath, item: item)
        })
        present(alert, animated: true)
    }

    private func animateDeletion(at indexPath: IndexPath, item: InventoryItem) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            viewModel.deleteItem(id: item.id)
            return
        }

        UIView.animate(withDuration: 0.25, animations: {
            cell.contentView.alpha = 0
        }, completion: { [weak self] _ in
            cell.contentView.alpha = 1
            self?.viewModel.deleteItem(id: item.id)
        })
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos inválidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}

extension InventoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InventoryItemCell.reuseIdentifier, for: indexPath) as? InventoryItemCell else {
            return UITableViewCell()
        }
        let item = viewModel.item(at: indexPath.row)
        let shouldAnimate = cell.configure(with: item)
        if shouldAnimate {
            cell.animateLowStock()
        }
        return cell
    }
}

extension InventoryListViewController: UITableViewDelegate {
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
            let item = self.viewModel.item(at: indexPath.row)
            self.presentItemForm(context: .edit(item))
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
