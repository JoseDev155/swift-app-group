//
//  StudyViewModel.swift
//  StudyCards
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class StudyViewModel {
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

    func pairsCount() -> Int {
        store.pairsDictionary().count
    }
}
