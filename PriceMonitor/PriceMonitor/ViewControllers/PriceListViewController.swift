//
//  PriceListViewController.swift
//  PriceMonitor
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class PriceListViewController: UIViewController {
    private let viewModel: PriceListViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: PriceListViewModel = PriceListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Precios"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPrice))
        let simulateButton = UIBarButtonItem(title: "Simular", style: .plain, target: self, action: #selector(simulateChanges))
        navigationItem.rightBarButtonItems = [addButton, simulateButton]
        navigationItem.leftBarButtonItem = editButtonItem

        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: PriceNotifications.pricesDidChange, object: nil)
        handleDataChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: PriceNotifications.pricesDidChange, object: nil)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PriceCell.self, forCellReuseIdentifier: PriceCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleDataChanged() {
        tableView.reloadData()
    }

    @objc private func addPrice() {
        presentPriceForm(context: .new)
    }

    @objc private func simulateChanges() {
        viewModel.simulatePrices()
    }

    private func presentPriceForm(context: EntryContext<PriceItem>) {
        let title: String
        let item: PriceItem?

        switch context {
        case .new:
            title = "Nuevo precio"
            item = nil
        case .edit(let current):
            title = "Editar precio"
            item = current
        }

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Nombre"
            textField.text = item?.name
        }
        alert.addTextField { textField in
            textField.placeholder = "Código de moneda (USD)"
            textField.text = item?.currencyCode
        }
        alert.addTextField { textField in
            textField.placeholder = "Valor"
            textField.keyboardType = .decimalPad
            if let item = item {
                textField.text = item.valueText
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Nota (opcional)"
            textField.text = item?.note
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let nameText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let currencyText = alert.textFields?.dropFirst().first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let valueText = alert.textFields?.dropFirst(2).first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let noteText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let normalizedValue = valueText.replacingOccurrences(of: ",", with: ".")

            guard !nameText.isEmpty else {
                self.presentValidationAlert(message: "Ingresa un nombre válido.")
                return
            }

            guard currencyText.count >= 2 else {
                self.presentValidationAlert(message: "Ingresa un código de moneda válido.")
                return
            }

            guard let value = Double(normalizedValue), value > 0 else {
                self.presentValidationAlert(message: "Ingresa un valor válido.")
                return
            }

            if let item = item {
                self.viewModel.updatePrice(id: item.id, name: nameText, currencyCode: currencyText, value: value, note: noteText)
            } else {
                self.viewModel.addPrice(name: nameText, currencyCode: currencyText, value: value, note: noteText)
            }
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func confirmDelete(at indexPath: IndexPath) {
        let item = viewModel.price(at: indexPath.row)
        let alert = UIAlertController(
            title: "Eliminar precio",
            message: "Deseas eliminar \"\(item.name)\"?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.viewModel.deletePrice(id: item.id)
        })
        present(alert, animated: true)
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos inválidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}

extension PriceListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.prices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PriceCell.reuseIdentifier, for: indexPath) as? PriceCell else {
            return UITableViewCell()
        }
        let item = viewModel.price(at: indexPath.row)
        let shouldAnimate = cell.configure(with: item)
        if shouldAnimate {
            cell.animateIncrease()
        }
        return cell
    }
}

extension PriceListViewController: UITableViewDelegate {
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
            let item = self.viewModel.price(at: indexPath.row)
            self.presentPriceForm(context: .edit(item))
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
