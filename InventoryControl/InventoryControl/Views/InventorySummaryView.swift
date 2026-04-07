//
//  InventorySummaryView.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class InventorySummaryView: UIView {
    private let titleLabel = UILabel()
    private let totalLabel = UILabel()
    private let lowLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(total: Int, lowStock: Int) {
        titleLabel.text = "Resumen"
        totalLabel.text = "Total: \(total)"
        lowLabel.text = lowStock > 0 ? "Bajo stock: \(lowStock)" : "Sin alertas"
        lowLabel.textColor = lowStock > 0 ? .systemRed : .secondaryLabel

        if lowStock > 0 {
            pulseWarning()
        }
    }

    private func pulseWarning() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.05
        animation.duration = 0.2
        animation.autoreverses = true
        animation.repeatCount = 2
        lowLabel.layer.add(animation, forKey: "pulse")
    }

    private func configureView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.masksToBounds = true

        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .secondaryLabel

        totalLabel.font = .preferredFont(forTextStyle: .title2)
        totalLabel.textColor = .label

        lowLabel.font = .preferredFont(forTextStyle: .footnote)
        lowLabel.textColor = .secondaryLabel

        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(totalLabel)
        stackView.addArrangedSubview(lowLabel)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
