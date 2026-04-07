//
//  SleepEntry.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum SleepQuality: String, Codable, CaseIterable {
    case low
    case medium
    case high

    var title: String {
        switch self {
        case .low:
            return "Baja"
        case .medium:
            return "Media"
        case .high:
            return "Alta"
        }
    }

    static func fromInput(_ text: String) -> SleepQuality? {
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "baja", "low":
            return .low
        case "media", "medium":
            return .medium
        case "alta", "high":
            return .high
        default:
            return nil
        }
    }
}

struct SleepEntry: Hashable, Codable {
    let id: String
    let date: Date
    let hours: Double
    let quality: SleepQuality
    let note: String
}
