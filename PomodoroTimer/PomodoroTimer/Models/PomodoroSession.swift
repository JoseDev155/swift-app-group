//
//  PomodoroSession.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct PomodoroSession: Hashable, Codable {
    let id: String
    let mode: PomodoroMode
    let durationMinutes: Int
    let completedAt: Date
    let note: String
}

extension PomodoroSession {
    var durationText: String {
        "\(durationMinutes) min"
    }
}

extension Date {
    private static let pomodoroDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let pomodoroTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()

    private static let pomodoroDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    func pomodoroDayKey() -> String {
        Date.pomodoroDayFormatter.string(from: self)
    }

    func pomodoroTimeLabel() -> String {
        Date.pomodoroTimeFormatter.string(from: self)
    }

    func pomodoroDayLabel() -> String {
        Date.pomodoroDisplayFormatter.string(from: self)
    }
}
