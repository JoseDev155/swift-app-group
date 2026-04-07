//
//  InventoryItemCell.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class InventoryItemCell: UITableViewCell {
    static let reuseIdentifier = "InventoryItemCell"

    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    private let locationLabel = UILabel()
    private let stockLabel = UILabel()
    private let noteLabel = UILabel()
    private let timeLabel = UILabel()
    private let badgeLabel = UILabel()
    private let badgeView = UIView()
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
        badgeView.isHidden = true
        badgeView.layer.removeAllAnimations()
    }

    func configure(with item: InventoryItem) -> Bool {
        iconView.image = UIImage(systemName: "shippingbox.fill")
        iconView.tintColor = item.isLowStock ? .systemRed : .systemIndigo

        nameLabel.text = item.name
        locationLabel.text = item.locationText
        stockLabel.text = item.stockText
        noteLabel.text = item.note.isEmpty ? "Sin nota" : item.note
        timeLabel.text = "Actualizado \(item.updatedAt.inventoryTimeLabel())"

        badgeLabel.text = "Bajo stock"
        badgeView.isHidden = !item.isLowStock
        badgeView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
        badgeLabel.textColor = .systemRed

        return item.isLowStock
    }

    func animateLowStock() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.3
        animation.duration = 0.3
        animation.autoreverses = true
        animation.repeatCount = 2
        badgeView.layer.add(animation, forKey: "blink")
    }

    private func configureView() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        iconView.backgroundColor = UIColor.systemGray6
        iconView.layer.cornerRadius = 10

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        locationLabel.font = .preferredFont(forTextStyle: .subheadline)
        locationLabel.textColor = .secondaryLabel
        stockLabel.font = .preferredFont(forTextStyle: .subheadline)
        stockLabel.textColor = .label
        noteLabel.font = .preferredFont(forTextStyle: .footnote)
        noteLabel.textColor = .secondaryLabel
        noteLabel.numberOfLines = 2
        timeLabel.font = .preferredFont(forTextStyle: .caption1)
        timeLabel.textColor = .tertiaryLabel

        badgeLabel.font = .preferredFont(forTextStyle: .caption1)
        badgeLabel.textAlignment = .center

        badgeView.layer.cornerRadius = 10
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.isHidden = true
        badgeView.addSubview(badgeLabel)
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(stockLabel)
        stackView.addArrangedSubview(badgeView)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(noteLabel)

        contentView.addSubview(iconView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 46),
            iconView.heightAnchor.constraint(equalToConstant: 46),

            stackView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 8),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -8),
            badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 4),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -4)
        ])
    }
}
