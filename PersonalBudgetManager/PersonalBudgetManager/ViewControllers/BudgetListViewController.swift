//
//  BudgetListViewController.swift
//  PersonalBudgetManager
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class BudgetListViewController: UIViewController {
    private let viewModel: BudgetListViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let limitLabel = UILabel()
    private let totalLabel = UILabel()
    private let warningView = LimitWarningView()
    private let summaryStack = UIStackView()
    private var hasShownLimitAlert = false

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()

    init(viewModel: BudgetListViewModel = BudgetListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movimientos"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Limite", style: .plain, target: self, action: #selector(editLimit)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntry))
        ]
        navigationItem.leftBarButtonItem = editButtonItem

        configureSummary()
        configureTableView()
        updateSummary(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEntriesChanged), name: BudgetNotifications.entriesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEntriesChanged), name: BudgetNotifications.limitDidChange, object: nil)
        updateSummary(animated: false)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: BudgetNotifications.entriesDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: BudgetNotifications.limitDidChange, object: nil)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    private func configureSummary() {
        summaryStack.arrangedSubviews.forEach { summaryStack.removeArrangedSubview($0); $0.removeFromSuperview() }
        summaryStack.addArrangedSubview(limitLabel)
        summaryStack.addArrangedSubview(totalLabel)
        summaryStack.addArrangedSubview(warningView)
        summaryStack.axis = .vertical
        summaryStack.spacing = 8

        limitLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        limitLabel.textColor = .secondaryLabel
        totalLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        totalLabel.textColor = .label

        summaryStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryStack)

        NSLayoutConstraint.activate([
            summaryStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            summaryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EntryCell.self, forCellReuseIdentifier: EntryCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: summaryStack.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleEntriesChanged() {
        updateSummary(animated: true)
        tableView.reloadData()
    }

    private func updateSummary(animated: Bool) {
        let limitText = formatter.string(from: NSNumber(value: viewModel.monthlyLimit)) ?? "0"
        let totalExpense = formatter.string(from: NSNumber(value: viewModel.total(for: .expense))) ?? "0"
        limitLabel.text = "Limite mensual: \(limitText)"
        totalLabel.text = "Total gastos: \(totalExpense)"

        if viewModel.exceedsLimit() {
            warningView.show(message: "Limite superado. Revisa tus gastos.", animated: animated)
            presentLimitAlertIfNeeded()
        } else {
            warningView.hide()
            hasShownLimitAlert = false
        }
    }

    private func presentLimitAlertIfNeeded() {
        guard !hasShownLimitAlert else { return }
        hasShownLimitAlert = true
        let alert = UIAlertController(
            title: "Limite superado",
            message: "Has excedido el limite de gastos definido.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }

    @objc private func addEntry() {
        let sheet = UIAlertController(title: "Nuevo movimiento", message: "Selecciona el tipo", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Gasto", style: .default) { [weak self] _ in
            self?.presentEntryForm(title: "Nuevo gasto", entry: nil, type: .expense, index: nil)
        })
        sheet.addAction(UIAlertAction(title: "Ingreso", style: .default) { [weak self] _ in
            self?.presentEntryForm(title: "Nuevo ingreso", entry: nil, type: .income, index: nil)
        })
        sheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(sheet, animated: true)
    }

    @objc private func editLimit() {
        let alert = UIAlertController(title: "Limite mensual", message: "Define tu limite de gastos.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Monto"
            textField.keyboardType = .decimalPad
            textField.text = String(format: "%.2f", self.viewModel.monthlyLimit)
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let limitText = alert.textFields?.first?.text ?? ""
            guard let limit = Double(limitText.replacingOccurrences(of: ",", with: ".")), limit > 0 else {
                self.presentValidationAlert(message: "Ingresa un monto valido.")
                return
            }
            self.viewModel.setMonthlyLimit(limit)
            self.updateSummary(animated: true)
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func presentEntryForm(title: String, entry: BudgetEntry?, type: EntryType, index: Int?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Titulo"
            textField.text = entry?.title
        }
        alert.addTextField { textField in
            textField.placeholder = "Monto"
            textField.keyboardType = .decimalPad
            if let amount = entry?.amount {
                textField.text = String(format: "%.2f", amount)
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Categoria"
            textField.text = entry?.category
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let titleText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let amountText = alert.textFields?[1].text ?? ""
            let categoryText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard !titleText.isEmpty, !categoryText.isEmpty else {
                self.presentValidationAlert(message: "Completa todos los campos.")
                return
            }
            guard let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")), amount > 0 else {
                self.presentValidationAlert(message: "Ingresa un monto valido.")
                return
            }

            if let index = index {
                self.viewModel.updateEntry(at: index, title: titleText, amount: amount, category: categoryText, type: type)
            } else {
                _ = self.viewModel.addEntry(title: titleText, amount: amount, category: categoryText, type: type)
            }
            self.tableView.reloadData()
            self.updateSummary(animated: true)
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func confirmDelete(at indexPath: IndexPath) {
        let entry = viewModel.entry(at: indexPath.row)
        let alert = UIAlertController(
            title: "Eliminar movimiento",
            message: "Deseas eliminar \"\(entry.title)\"?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteEntry(at: indexPath.row)
            self?.tableView.reloadData()
            self?.updateSummary(animated: true)
        })
        present(alert, animated: true)
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos invalidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}

extension BudgetListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier, for: indexPath) as? EntryCell else {
            return UITableViewCell()
        }
        let entry = viewModel.entry(at: indexPath.row)
        cell.configure(with: entry, formatter: formatter)
        return cell
    }
}

extension BudgetListViewController: UITableViewDelegate {
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
            let entry = self.viewModel.entry(at: indexPath.row)
            self.presentEntryForm(title: "Editar movimiento", entry: entry, type: entry.type, index: indexPath.row)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

