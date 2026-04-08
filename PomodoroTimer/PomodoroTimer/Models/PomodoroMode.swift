//
//  PomodoroMode.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum PomodoroMode: String, Codable, CaseIterable {
    case work
    case shortBreak
    case longBreak

    var title: String {
        switch self {
        case .work:
            return "Trabajo"
        case .shortBreak:
            return "Descanso corto"
        case .longBreak:
            return "Descanso largo"
        }
    }

    static func fromInput(_ text: String) -> PomodoroMode? {
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "trabajo", "work":
            return .work
        case "descanso corto", "corto", "short", "short break":
            return .shortBreak
        case "descanso largo", "largo", "long", "long break":
            return .longBreak
        default:
            return nil
        }
    }
}
