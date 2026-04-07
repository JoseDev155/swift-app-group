//
//  SettingsViewController.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let hydrationSummaryView = SummaryCardView()
    private let sleepSummaryView = SummaryCardView()
    private let hydrationDetailLabel = UILabel()
    private let sleepDetailLabel = UILabel()
    private let qualityDetailLabel = UILabel()

    init(viewModel: SettingsViewModel = SettingsViewModel()) {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Metas", style: .plain, target: self, action: #selector(editGoals))
        configureLayout()
        configureLabels()
        updateContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: HydrationSleepNotifications.waterDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: HydrationSleepNotifications.sleepDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: HydrationSleepNotifications.settingsDidChange, object: nil)
        handleDataChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: HydrationSleepNotifications.waterDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: HydrationSleepNotifications.sleepDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: HydrationSleepNotifications.settingsDidChange, object: nil)
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(hydrationSummaryView)
        stackView.addArrangedSubview(sleepSummaryView)
        stackView.addArrangedSubview(hydrationDetailLabel)
        stackView.addArrangedSubview(sleepDetailLabel)
        stackView.addArrangedSubview(qualityDetailLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func configureLabels() {
        hydrationDetailLabel.font = .preferredFont(forTextStyle: .footnote)
        hydrationDetailLabel.textColor = .secondaryLabel
        hydrationDetailLabel.numberOfLines = 0

        sleepDetailLabel.font = .preferredFont(forTextStyle: .footnote)
        sleepDetailLabel.textColor = .secondaryLabel
        sleepDetailLabel.numberOfLines = 0

        qualityDetailLabel.font = .preferredFont(forTextStyle: .footnote)
        qualityDetailLabel.textColor = .secondaryLabel
        qualityDetailLabel.numberOfLines = 0
    }

    private func updateContent() {
        let hydrationGoal = viewModel.hydrationGoalMl
        let hydrationTotal = viewModel.hydrationToday
        let hydrationSubtitle = "Meta diaria: \(hydrationGoal) ml"
        hydrationSummaryView.configure(title: "Agua de hoy", value: "\(hydrationTotal) ml", subtitle: hydrationSubtitle, progress: viewModel.hydrationProgress)

        let sleepGoal = viewModel.sleepGoalHours
        let sleepTotal = viewModel.sleepToday
        let sleepGoalText = String(format: "%.1f", sleepGoal)
        let sleepTotalText = String(format: "%.1f", sleepTotal)
        let sleepSubtitle = "Meta diaria: \(sleepGoalText) h"
        sleepSummaryView.configure(title: "Sueno de hoy", value: "\(sleepTotalText) h", subtitle: sleepSubtitle, progress: viewModel.sleepProgress)

        let hydrationLines = viewModel.hydrationSummaryLines(limit: 5)
        if hydrationLines.isEmpty {
            hydrationDetailLabel.text = "Agua por dia: sin registros."
        } else {
            hydrationDetailLabel.text = "Agua por dia:\n" + hydrationLines.joined(separator: "\n")
        }

        let sleepLines = viewModel.sleepSummaryLines(limit: 5)
        if sleepLines.isEmpty {
            sleepDetailLabel.text = "Sueno por dia: sin registros."
        } else {
            sleepDetailLabel.text = "Sueno por dia:\n" + sleepLines.joined(separator: "\n")
        }

        qualityDetailLabel.text = viewModel.qualitySummaryLine()
    }

    @objc private func handleDataChanged() {
        updateContent()
    }

    @objc private func editGoals() {
        let alert = UIAlertController(title: "Metas diarias", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Meta de agua (ml)"
            textField.keyboardType = .numberPad
            textField.text = "\(self.viewModel.hydrationGoalMl)"
        }
        alert.addTextField { textField in
            textField.placeholder = "Meta de sueno (horas)"
            textField.keyboardType = .decimalPad
            textField.text = String(format: "%.1f", self.viewModel.sleepGoalHours)
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let hydrationText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sleepText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let normalizedSleep = sleepText.replacingOccurrences(of: ",", with: ".")

            guard let hydrationGoal = Int(hydrationText), hydrationGoal > 0 else {
                self.presentValidationAlert(message: "Ingresa una meta valida para el agua.")
                return
            }

            guard let sleepGoal = Double(normalizedSleep), sleepGoal > 0 else {
                self.presentValidationAlert(message: "Ingresa una meta valida para el sueno.")
                return
            }

            self.viewModel.updateGoals(hydrationGoalMl: hydrationGoal, sleepGoalHours: sleepGoal)
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos invalidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}
