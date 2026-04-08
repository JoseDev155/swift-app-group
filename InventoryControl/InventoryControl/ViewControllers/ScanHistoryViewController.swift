//
//  ScanHistoryViewController.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class ScanHistoryViewController: UIViewController {
    private let viewModel: ScanHistoryViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: ScanHistoryViewModel = ScanHistoryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Historial"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Limpiar", style: .plain, target: self, action: #selector(clearHistory))
        configureTableView()
        updateEmptyState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHistoryChanged), name: InventoryNotifications.scanHistoryDidChange, object: nil)
        handleHistoryChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: InventoryNotifications.scanHistoryDidChange, object: nil)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScanHistoryCell.self, forCellReuseIdentifier: ScanHistoryCell.reuseIdentifier)
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

    @objc private func handleHistoryChanged() {
        tableView.reloadData()
        updateEmptyState()
    }

    private func updateEmptyState() {
        if viewModel.totalCount == 0 {
            let label = UILabel()
            label.text = "Sin escaneos registrados."
            label.textColor = .secondaryLabel
            label.font = .preferredFont(forTextStyle: .body)
            label.textAlignment = .center
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }

    @objc private func clearHistory() {
        guard viewModel.totalCount > 0 else { return }
        let alert = UIAlertController(title: "Limpiar historial", message: "Esta acción eliminará todos los escaneos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.viewModel.clearHistory()
        })
        present(alert, animated: true)
    }
}

extension ScanHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScanHistoryCell.reuseIdentifier, for: indexPath) as? ScanHistoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.record(at: indexPath.row))
        return cell
    }
}

extension ScanHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
