//
//  SettingsViewController.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    private let workLabel = UILabel()
    private let shortLabel = UILabel()
    private let longLabel = UILabel()
    private let modeSummaryLabel = UILabel()
    private let daySummaryLabel = UILabel()

    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Configuración"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(editSettings))
        configureLayout()
        configureLabels()
        updateContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: PomodoroNotifications.sessionsDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: PomodoroNotifications.settingsDidChange, object: nil)
        handleDataChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: PomodoroNotifications.sessionsDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: PomodoroNotifications.settingsDidChange, object: nil)
    }

    private func configureLayout() {
        let stackView = UIStackView(arrangedSubviews: [workLabel, shortLabel, longLabel, modeSummaryLabel, daySummaryLabel])
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
        workLabel.font = .preferredFont(forTextStyle: .headline)
        shortLabel.font = .preferredFont(forTextStyle: .headline)
        longLabel.font = .preferredFont(forTextStyle: .headline)

        modeSummaryLabel.font = .preferredFont(forTextStyle: .footnote)
        modeSummaryLabel.textColor = .secondaryLabel
        modeSummaryLabel.numberOfLines = 0

        daySummaryLabel.font = .preferredFont(forTextStyle: .footnote)
        daySummaryLabel.textColor = .secondaryLabel
        daySummaryLabel.numberOfLines = 0
    }

    private func updateContent() {
        let settings = viewModel.settings
        workLabel.text = "Trabajo: \(settings.workMinutes) min"
        shortLabel.text = "Descanso corto: \(settings.shortBreakMinutes) min"
        longLabel.text = "Descanso largo: \(settings.longBreakMinutes) min"
        modeSummaryLabel.text = viewModel.modeSummaryText()
        daySummaryLabel.text = viewModel.daySummaryText()
    }

    @objc private func handleDataChanged() {
        updateContent()
    }

    @objc private func editSettings() {
        let settings = viewModel.settings
        let alert = UIAlertController(title: "Editar tiempos", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Trabajo (minutos)"
            textField.keyboardType = .numberPad
            textField.text = "\(settings.workMinutes)"
        }
        alert.addTextField { textField in
            textField.placeholder = "Descanso corto (minutos)"
            textField.keyboardType = .numberPad
            textField.text = "\(settings.shortBreakMinutes)"
        }
        alert.addTextField { textField in
            textField.placeholder = "Descanso largo (minutos)"
            textField.keyboardType = .numberPad
            textField.text = "\(settings.longBreakMinutes)"
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let workText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let shortText = alert.textFields?.dropFirst().first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let longText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard let work = Int(workText), work > 0 else {
                self.presentValidationAlert(message: "Ingresa un tiempo válido para trabajo.")
                return
            }

            guard let shortBreak = Int(shortText), shortBreak > 0 else {
                self.presentValidationAlert(message: "Ingresa un tiempo válido para descanso corto.")
                return
            }

            guard let longBreak = Int(longText), longBreak > 0 else {
                self.presentValidationAlert(message: "Ingresa un tiempo válido para descanso largo.")
                return
            }

            self.viewModel.updateSettings(workMinutes: work, shortBreakMinutes: shortBreak, longBreakMinutes: longBreak)
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
