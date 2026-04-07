//
//  CardFlipView.swift
//  StudyCards
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class CardFlipView: UIView {
    private let questionLabel = UILabel()
    private let answerLabel = UILabel()
    private var isShowingAnswer = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func setCard(question: String, answer: String) {
        questionLabel.text = question
        answerLabel.text = answer
        showQuestion()
    }

    func showQuestion() {
        questionLabel.isHidden = false
        answerLabel.isHidden = true
        isShowingAnswer = false
    }

    func flip() {
        let showAnswer = !isShowingAnswer
        let options: UIView.AnimationOptions = showAnswer ? .transitionFlipFromRight : .transitionFlipFromLeft

        UIView.transition(with: self, duration: 0.35, options: [options, .showHideTransitionViews], animations: {
            self.questionLabel.isHidden = showAnswer
            self.answerLabel.isHidden = !showAnswer
        }, completion: { _ in
            self.isShowingAnswer = showAnswer
        })
    }

    private func configure() {
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor

        questionLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        questionLabel.textAlignment = .center
        questionLabel.textColor = .label
        questionLabel.numberOfLines = 0

        answerLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        answerLabel.textAlignment = .center
        answerLabel.textColor = .label
        answerLabel.numberOfLines = 0
        answerLabel.isHidden = true

        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(questionLabel)
        addSubview(answerLabel)

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            answerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            answerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            answerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            answerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
