//
//  PriorityBadgeView.swift
//  ToDoList
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class PriorityBadgeView: UIView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func setPriority(_ priority: TaskPriority) {
        titleLabel.text = priority.title
        switch priority {
        case .high:
            backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
            titleLabel.textColor = .systemRed
        case .medium:
            backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
            titleLabel.textColor = .systemOrange
        case .low:
            backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            titleLabel.textColor = .systemGreen
        }
    }

    private func configure() {
        layer.cornerRadius = 10
        backgroundColor = UIColor.systemGray5

        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.textAlignment = .center

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
