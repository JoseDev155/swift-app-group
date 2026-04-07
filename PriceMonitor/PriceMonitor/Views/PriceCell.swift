//
//  PriceCell.swift
//  PriceMonitor
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class PriceCell: UITableViewCell {
    static let reuseIdentifier = "PriceCell"

    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    private let metaLabel = UILabel()
    private let noteLabel = UILabel()
    private let changeLabel = UILabel()
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.textColor = .label
        changeLabel.textColor = .secondaryLabel
        valueLabel.layer.removeAllAnimations()
    }

    func configure(with item: PriceItem) -> Bool {
        nameLabel.text = item.name
        valueLabel.text = "\(item.currencyCode) \(item.valueText)"
        metaLabel.text = "Actualizado \(item.updatedAt.priceTimeLabel())"
        noteLabel.text = item.note.isEmpty ? "Sin nota" : item.note
        changeLabel.text = item.changeText

        if item.changeValue > 0 {
            valueLabel.textColor = .systemGreen
            changeLabel.textColor = .systemGreen
            return true
        }

        if item.changeValue < 0 {
            valueLabel.textColor = .systemRed
            changeLabel.textColor = .systemRed
            return false
        }

        valueLabel.textColor = .label
        changeLabel.textColor = .secondaryLabel
        return false
    }

    func animateIncrease() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.2
        animation.duration = 0.25
        animation.autoreverses = true
        animation.repeatCount = 2
        valueLabel.layer.add(animation, forKey: "blink")
    }

    private func configureView() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        valueLabel.font = .preferredFont(forTextStyle: .title3)
        metaLabel.font = .preferredFont(forTextStyle: .caption1)
        metaLabel.textColor = .secondaryLabel
        noteLabel.font = .preferredFont(forTextStyle: .footnote)
        noteLabel.textColor = .secondaryLabel
        noteLabel.numberOfLines = 2
        changeLabel.font = .preferredFont(forTextStyle: .caption1)
        changeLabel.textColor = .secondaryLabel

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(changeLabel)
        stackView.addArrangedSubview(metaLabel)
        stackView.addArrangedSubview(noteLabel)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
