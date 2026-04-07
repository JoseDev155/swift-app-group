//
//  TravelEntry.swift
//  TravelDiary
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct TravelEntry: Hashable, Codable {
    let id: String
    let country: String
    let city: String
    let notes: String
    let date: Date
}
