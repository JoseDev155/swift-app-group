//
//  Flashcard.swift
//  StudyCards
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct Flashcard: Hashable, Codable {
    let id: String
    let question: String
    let answer: String
    let createdAt: Date
}
