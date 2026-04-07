//
//  TravelPreferences.swift
//  TravelDiary
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum DistanceUnit: String, Codable, CaseIterable {
    case kilometers
    case miles

    var title: String {
        switch self {
        case .kilometers:
            return "Kilómetros"
        case .miles:
            return "Millas"
        }
    }

    var symbol: String {
        switch self {
        case .kilometers:
            return "km"
        case .miles:
            return "mi"
        }
    }
}

struct TravelPreferences: Hashable, Codable {
    let distanceUnit: DistanceUnit
    let currencyCode: String
}
