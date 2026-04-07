import UIKit

final class TravelSettingsViewController: UIViewController {
    private let viewModel: TravelSettingsViewModel
    private let unitLabel = UILabel()
    private let currencyLabel = UILabel()

    init(viewModel: TravelSettingsViewModel = TravelSettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ajustes"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureLayout()
        updateLabels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePreferencesChanged), name: TravelNotifications.preferencesDidChange, object: nil)
        updateLabels()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: TravelNotifications.preferencesDidChange, object: nil)
    }

    private func configureLayout() {
        unitLabel.font = UIFont.preferredFont(forTextStyle: .body)
        currencyLabel.font = UIFont.preferredFont(forTextStyle: .body)

        let button = UIButton(type: .system)
        button.setTitle("Editar preferencias", for: .normal)
        button.addTarget(self, action: #selector(editPreferences), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [unitLabel, currencyLabel, button])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading

        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func editPreferences() {
        let alert = UIAlertController(title: "Preferencias", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Unidad (Kilometros/Millas)"
            textField.text = self.viewModel.preferences.distanceUnit.title
        }
        alert.addTextField { textField in
            textField.placeholder = "Moneda (USD, EUR, etc)"
            textField.text = self.viewModel.preferences.currencyCode
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let unitText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let currencyText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard let unit = self.unit(from: unitText), !currencyText.isEmpty else {
                self.presentValidationAlert(message: "Completa las preferencias.")
                return
            }

            self.viewModel.updatePreferences(distanceUnit: unit, currencyCode: currencyText.uppercased())
            self.updateLabels()
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    @objc private func handlePreferencesChanged() {
        updateLabels()
    }

    private func updateLabels() {
        let preferences = viewModel.preferences
        unitLabel.text = "Unidad: \(preferences.distanceUnit.title)"
        currencyLabel.text = "Moneda: \(preferences.currencyCode)"
    }

    private func unit(from value: String) -> DistanceUnit? {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "kilometros", "km":
            return .kilometers
        case "millas", "mi":
            return .miles
        default:
            return nil
        }
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos invalidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}
