//
//  StudyStore.swift
//  StudyCards
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

protocol StudyStoreProtocol {
    var cards: [Flashcard] { get }
    func addCard(question: String, answer: String) -> Flashcard
    func updateCard(id: String, question: String, answer: String)
    func deleteCard(id: String)
    func pairsDictionary() -> [String: String]
}

final class StudyStore: StudyStoreProtocol {
    static let shared = StudyStore()

    private let defaults: UserDefaults
    private static let cardsKey = "StudyCardsItems"

    private(set) var cards: [Flashcard]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.cards = StudyStore.loadCards(defaults: defaults)
    }

    func addCard(question: String, answer: String) -> Flashcard {
        let card = Flashcard(
            id: UUID().uuidString,
            question: question,
            answer: answer,
            createdAt: Date()
        )
        cards.insert(card, at: 0)
        saveCards()
        notifyCardsChanged()
        return card
    }

    func updateCard(id: String, question: String, answer: String) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        let current = cards[index]
        cards[index] = Flashcard(
            id: current.id,
            question: question,
            answer: answer,
            createdAt: current.createdAt
        )
        saveCards()
        notifyCardsChanged()
    }

    func deleteCard(id: String) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        cards.remove(at: index)
        saveCards()
        notifyCardsChanged()
    }

    func pairsDictionary() -> [String: String] {
        var pairs: [String: String] = [:]
        for card in cards {
            pairs[card.question] = card.answer
        }
        return pairs
    }

    private func saveCards() {
        guard let data = try? JSONEncoder().encode(cards) else { return }
        defaults.set(data, forKey: StudyStore.cardsKey)
    }

    private func notifyCardsChanged() {
        NotificationCenter.default.post(name: StudyNotifications.cardsDidChange, object: nil)
    }

    private static func loadCards(defaults: UserDefaults) -> [Flashcard] {
        if let data = defaults.data(forKey: StudyStore.cardsKey),
           let stored = try? JSONDecoder().decode([Flashcard].self, from: data) {
            return stored
        }
        return []
    }
}
