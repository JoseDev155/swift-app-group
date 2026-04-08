//
//  SettingsViewModel.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class SettingsViewModel {
    private let store: PomodoroStoreProtocol

    init(store: PomodoroStoreProtocol = PomodoroStore.shared) {
        self.store = store
    }

    var settings: PomodoroSettings {
        store.settings
    }

    func updateSettings(workMinutes: Int, shortBreakMinutes: Int, longBreakMinutes: Int) {
        store.updateSettings(workMinutes: workMinutes, shortBreakMinutes: shortBreakMinutes, longBreakMinutes: longBreakMinutes)
    }

    func modeSummaryText() -> String {
        let summary = store.countsByMode()
        guard !summary.isEmpty else {
            return "Sesiones por modo: sin registros."
        }

        let lines = PomodoroMode.allCases.map { mode in
            let count = summary[mode, default: 0]
            return "\(mode.title): \(count)"
        }

        return "Sesiones por modo:\n" + lines.joined(separator: "\n")
    }

    func daySummaryText() -> String {
        let summary = store.sessionsByDayAndMode()
        guard !summary.isEmpty else {
            return "Por día: sin registros."
        }

        let lines = summary.keys.sorted(by: >).map { (key: String) -> String in
            let modes = summary[key] ?? [:]
            let details = PomodoroMode.allCases.map { (mode: PomodoroMode) -> String in
                "\(mode.title): \(modes[mode, default: 0])"
            }
            let detailText = details.joined(separator: " · ")
            let label = SettingsViewModel.displayDay(from: key)
            return "\(label) · \(detailText)"
        }

        return "Por día:\n" + lines.joined(separator: "\n")
    }

    private static func displayDay(from key: String) -> String {
        if let date = SettingsViewModel.dayFormatter.date(from: key) {
            return date.pomodoroDayLabel()
        }
        return key
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
