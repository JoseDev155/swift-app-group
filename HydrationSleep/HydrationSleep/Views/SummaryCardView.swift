//
//  SummaryCardView.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class SummaryCardView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let ringView = ProgressRingView()
    private let textStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, value: String, subtitle: String, progress: Double) {
        titleLabel.text = title
        valueLabel.text = value
        subtitleLabel.text = subtitle
        ringView.setProgress(CGFloat(progress), animated: true)
        if progress >= 1 {
            ringView.pulse()
        }
    }

    private func configureView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.masksToBounds = true

        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .secondaryLabel

        valueLabel.font = .preferredFont(forTextStyle: .title2)
        valueLabel.textColor = .label

        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(valueLabel)
        textStack.addArrangedSubview(subtitleLabel)

        ringView.translatesAutoresizingMaskIntoConstraints = false

        let container = UIStackView(arrangedSubviews: [ringView, textStack])
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
