//
//  StudyViewController.swift
//  StudyCards
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class StudyViewController: UIViewController {
    private let viewModel: StudyViewModel
    private let cardView = CardFlipView()
    private let statusLabel = UILabel()
    private let flipButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)

    private var currentIndex = 0

    init(viewModel: StudyViewModel = StudyViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Estudio"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureLayout()
        updateCard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCardsChanged), name: StudyNotifications.cardsDidChange, object: nil)
        updateCard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: StudyNotifications.cardsDidChange, object: nil)
    }

    private func configureLayout() {
        statusLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center

        flipButton.setTitle("Voltear", for: .normal)
        flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)

        nextButton.setTitle("Siguiente", for: .normal)
        nextButton.addTarget(self, action: #selector(nextCard), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [flipButton, nextButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        cardView.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(cardView)
        view.addSubview(statusLabel)
        view.addSubview(buttonStack)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        cardView.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardView.heightAnchor.constraint(equalToConstant: 240),

            statusLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            buttonStack.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    @objc private func handleCardsChanged() {
        updateCard()
    }

    private func updateCard() {
        let cards = viewModel.cards
        if cards.isEmpty {
            cardView.setCard(question: "Sin tarjetas", answer: "Agrega una nueva")
            cardView.showQuestion()
            statusLabel.text = "No hay tarjetas disponibles"
            flipButton.isEnabled = false
            nextButton.isEnabled = false
            return
        }

        if currentIndex >= cards.count {
            currentIndex = 0
        }

        let card = viewModel.card(at: currentIndex)
        cardView.setCard(question: card.question, answer: card.answer)
        cardView.showQuestion()
        flipButton.isEnabled = true
        nextButton.isEnabled = true

        let total = cards.count
        let pairs = viewModel.pairsCount()
        statusLabel.text = "Tarjeta \(currentIndex + 1) de \(total) - Pares: \(pairs)"
    }

    @objc private func flipCard() {
        guard !viewModel.cards.isEmpty else { return }
        cardView.flip()
    }

    @objc private func nextCard() {
        guard !viewModel.cards.isEmpty else { return }
        currentIndex += 1
        if currentIndex >= viewModel.cards.count {
            currentIndex = 0
        }
        updateCard()
    }
}
