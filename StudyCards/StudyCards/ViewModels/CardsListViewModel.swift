//
//  CardsListViewModel.swift
//  StudyCards
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class CardsListViewModel {
    private let store: StudyStoreProtocol

    init(store: StudyStoreProtocol = StudyStore.shared) {
        self.store = store
    }

    var cards: [Flashcard] {
        store.cards
    }

    func card(at index: Int) -> Flashcard {
        cards[index]
    }

    func addCard(question: String, answer: String) {
        _ = store.addCard(question: question, answer: answer)
    }

    func updateCard(at index: Int, question: String, answer: String) {
        let card = cards[index]
        store.updateCard(id: card.id, question: question, answer: answer)
    }

    func deleteCard(at index: Int) {
        let card = cards[index]
        store.deleteCard(id: card.id)
    }
}
