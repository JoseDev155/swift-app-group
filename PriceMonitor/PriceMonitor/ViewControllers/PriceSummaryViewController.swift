//
//  PriceSummaryViewController.swift
//  PriceMonitor
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class PriceSummaryViewController: UIViewController {
    private let viewModel: PriceSummaryViewModel
    private let totalLabel = UILabel()
    private let currencyLabel = UILabel()
    private let averageLabel = UILabel()
    private let updateLabel = UILabel()

    init(viewModel: PriceSummaryViewModel = PriceSummaryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resumen"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureLayout()
        configureLabels()
        updateContent()
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

    private func configureLayout() {
        let stackView = UIStackView(arrangedSubviews: [totalLabel, currencyLabel, averageLabel, updateLabel])
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
        totalLabel.font = .preferredFont(forTextStyle: .headline)
        totalLabel.textColor = .label

        currencyLabel.font = .preferredFont(forTextStyle: .footnote)
        currencyLabel.textColor = .secondaryLabel
        currencyLabel.numberOfLines = 0

        averageLabel.font = .preferredFont(forTextStyle: .footnote)
        averageLabel.textColor = .secondaryLabel
        averageLabel.numberOfLines = 0

        updateLabel.font = .preferredFont(forTextStyle: .caption1)
        updateLabel.textColor = .tertiaryLabel
        updateLabel.numberOfLines = 0
    }

    private func updateContent() {
        totalLabel.text = "Total monitoreado: \(viewModel.totalCount)"
        currencyLabel.text = viewModel.currencySummaryText()
        averageLabel.text = viewModel.averageSummaryText()
        updateLabel.text = viewModel.lastUpdateText()
    }

    @objc private func handleDataChanged() {
        updateContent()
    }
}
