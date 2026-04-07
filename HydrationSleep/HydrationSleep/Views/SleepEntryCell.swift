//
//  SleepEntryCell.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class SleepEntryCell: UITableViewCell {
    static let reuseIdentifier = "SleepEntryCell"

    private let titleLabel = UILabel()
    private let noteLabel = UILabel()
    private let timeLabel = UILabel()
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with entry: SleepEntry) {
        let hoursText = String(format: "%.1f", entry.hours)
        titleLabel.text = "\(hoursText) h · \(entry.quality.title)"
        noteLabel.text = entry.note.isEmpty ? "Sin nota" : entry.note
        timeLabel.text = entry.date.timeLabel()
    }

    private func configureView() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        noteLabel.font = .preferredFont(forTextStyle: .subheadline)
        noteLabel.textColor = .secondaryLabel
        timeLabel.font = .preferredFont(forTextStyle: .caption1)
        timeLabel.textColor = .tertiaryLabel

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(noteLabel)
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
