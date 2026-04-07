//
//  ProfileViewController.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    private let businessLabel = UILabel()
    private let managerLabel = UILabel()
    private let statsLabel = UILabel()
    private let aisleLabel = UILabel()

    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Perfil"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(editProfile))
        configureLayout()
        configureLabels()
        updateContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: InventoryNotifications.inventoryDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: InventoryNotifications.profileDidChange, object: nil)
        handleDataChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: InventoryNotifications.inventoryDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: InventoryNotifications.profileDidChange, object: nil)
    }

    private func configureLayout() {
        let stackView = UIStackView(arrangedSubviews: [businessLabel, managerLabel, statsLabel, aisleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureLabels() {
        businessLabel.font = .preferredFont(forTextStyle: .headline)
        businessLabel.textColor = .label

        managerLabel.font = .preferredFont(forTextStyle: .subheadline)
        managerLabel.textColor = .secondaryLabel

        statsLabel.font = .preferredFont(forTextStyle: .footnote)
        statsLabel.textColor = .secondaryLabel
        statsLabel.numberOfLines = 0

        aisleLabel.font = .preferredFont(forTextStyle: .footnote)
        aisleLabel.textColor = .secondaryLabel
        aisleLabel.numberOfLines = 0
    }

    private func updateContent() {
        businessLabel.text = viewModel.businessName
        managerLabel.text = "Encargado: \(viewModel.managerName)"
        statsLabel.text = "Total: \(viewModel.totalCount) · Bajo stock: \(viewModel.lowStockCount) · Mínimo base: \(viewModel.defaultMinStock)"
        aisleLabel.text = viewModel.aisleSummaryText()
    }

    @objc private func handleDataChanged() {
        updateContent()
    }

    @objc private func editProfile() {
        let alert = UIAlertController(title: "Datos del negocio", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Nombre del negocio"
            textField.text = self.viewModel.businessName
        }
        alert.addTextField { textField in
            textField.placeholder = "Encargado"
            textField.text = self.viewModel.managerName
        }
        alert.addTextField { textField in
            textField.placeholder = "Stock mínimo por defecto"
            textField.keyboardType = .numberPad
            textField.text = "\(self.viewModel.defaultMinStock)"
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let businessText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let managerText = alert.textFields?.dropFirst().first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let minText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard !businessText.isEmpty else {
                self.presentValidationAlert(message: "Ingresa un nombre válido.")
                return
            }

            guard !managerText.isEmpty else {
                self.presentValidationAlert(message: "Ingresa un encargado válido.")
                return
            }

            guard let minStock = Int(minText), minStock >= 0 else {
                self.presentValidationAlert(message: "Ingresa un mínimo válido.")
                return
            }

            self.viewModel.updateProfile(businessName: businessText, managerName: managerText, defaultMinStock: minStock)
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos inválidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}
