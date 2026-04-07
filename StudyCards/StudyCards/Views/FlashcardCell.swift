//
//  FlashcardCell.swift
//  StudyCards
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class FlashcardCell: UITableViewCell {
    static let reuseIdentifier = "FlashcardCell"

    private let questionLabel = UILabel()
    private let answerLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func configure(with card: Flashcard) {
        questionLabel.text = card.question
        answerLabel.text = card.answer
    }

    private func configure() {
        selectionStyle = .none

        questionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        questionLabel.textColor = .label

        answerLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        answerLabel.textColor = .secondaryLabel
        answerLabel.numberOfLines = 2

        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(questionLabel)
        contentView.addSubview(answerLabel)

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 6),
            answerLabel.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            answerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
