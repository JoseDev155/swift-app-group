//
//  ScanHistoryCell.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class ScanHistoryCell: UITableViewCell {
    static let reuseIdentifier = "ScanHistoryCell"

    private let nameLabel = UILabel()
    private let locationLabel = UILabel()
    private let quantityLabel = UILabel()
    private let timeLabel = UILabel()
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with record: ScanRecord) {
        nameLabel.text = record.itemName
        locationLabel.text = record.locationText
        quantityLabel.text = record.quantityText
        timeLabel.text = "Escaneado \(record.createdAt.inventoryTimeLabel())"

        if record.delivered < record.requested {
            quantityLabel.textColor = .systemRed
        } else {
            quantityLabel.textColor = .label
        }
    }

    private func configureView() {
        selectionStyle = .none

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        locationLabel.font = .preferredFont(forTextStyle: .subheadline)
        locationLabel.textColor = .secondaryLabel
        quantityLabel.font = .preferredFont(forTextStyle: .footnote)
        quantityLabel.textColor = .label
        timeLabel.font = .preferredFont(forTextStyle: .caption1)
        timeLabel.textColor = .tertiaryLabel

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(quantityLabel)
        stackView.addArrangedSubview(timeLabel)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
