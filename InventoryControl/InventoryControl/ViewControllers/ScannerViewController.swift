//
//  ScannerViewController.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class ScannerViewController: UIViewController {
    private let viewModel: ScannerViewModel
    private let infoLabel = UILabel()
    private let scanButton = UIButton(type: .system)
    private let cardView = UIView()

    init(viewModel: ScannerViewModel = ScannerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Escáner"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureLayout()
        configureCard()
        updateInfo(text: "Listo para escanear productos.")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInventoryChanged), name: InventoryNotifications.inventoryDidChange, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: InventoryNotifications.inventoryDidChange, object: nil)
    }

    private func configureLayout() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureCard() {
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 16

        infoLabel.font = .preferredFont(forTextStyle: .body)
        infoLabel.textColor = .label
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        scanButton.setTitle("Escanear producto", for: .normal)
        scanButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        scanButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(infoLabel)
        cardView.addSubview(scanButton)

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            scanButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            scanButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            scanButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }

    private func updateInfo(text: String) {
        infoLabel.text = text
    }

    @objc private func scanTapped() {
        switch viewModel.scanAvailability() {
        case .noInventory:
            presentStatusAlert(title: "Sin productos", message: "Aún no hay productos registrados en el inventario.")
            return
        case .noStock:
            presentStatusAlert(title: "Stock agotado", message: "Hay productos registrados, pero todos tienen stock 0.")
            return
        case .available:
            break
        }

        let alert = UIAlertController(title: "Escaneo rápido", message: "Puedes ingresar el ID, el nombre o la cantidad.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "ID del producto (opcional)"
        }
        alert.addTextField { textField in
            textField.placeholder = "Nombre del producto"
        }
        alert.addTextField { textField in
            textField.placeholder = "Cantidad (opcional)"
            textField.keyboardType = .numberPad
        }

        let confirmAction = UIAlertAction(title: "Agregar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let idText = alert.textFields?.first?.text
            let nameText = alert.textFields?.dropFirst().first?.text
            let quantityText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let requestedUnits = Int(quantityText).flatMap { $0 > 0 ? $0 : nil }

            switch self.viewModel.simulateScan(productId: idText, name: nameText, requestedUnits: requestedUnits) {
            case .purchased(let item, let requested, let delivered):
                self.updateInfo(text: "Venta: \(item.name) · Entregadas \(delivered) · Stock \(item.stock)")
                self.animateCard()
                if delivered < requested {
                    self.presentStatusAlert(
                        title: "Stock insuficiente",
                        message: "Se solicitaron \(requested) unidades, pero solo hay \(delivered) disponibles."
                    )
                }
            case .outOfStock(let item):
                self.presentStatusAlert(title: "Stock agotado", message: "No hay unidades disponibles de \(item.name).")
            case .notFound:
                self.presentStatusAlert(title: "Producto no encontrado", message: "No existe un producto con ese ID o nombre en el inventario.")
            }
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }

    private func presentStatusAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }

    private func animateCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.cardView.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.cardView.transform = .identity
            }
        })
    }

    @objc private func handleInventoryChanged() {
        updateInfo(text: "Inventario actualizado.")
    }
}
