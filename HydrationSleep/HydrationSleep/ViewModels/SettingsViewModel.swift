//
//  SettingsViewModel.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class SettingsViewModel {
    private let store: HydrationSleepStoreProtocol

    init(store: HydrationSleepStoreProtocol = HydrationSleepStore.shared) {
        self.store = store
    }

    var hydrationGoalMl: Int {
        store.settings.hydrationGoalMl
    }

    var sleepGoalHours: Double {
        store.settings.sleepGoalHours
    }

    var hydrationToday: Int {
        store.hydrationTotal(for: Date())
    }

    var sleepToday: Double {
        store.sleepTotal(for: Date())
    }

    var hydrationProgress: Double {
        let goal = max(hydrationGoalMl, 1)
        return min(Double(hydrationToday) / Double(goal), 1)
    }

    var sleepProgress: Double {
        let goal = max(sleepGoalHours, 0.1)
        return min(sleepToday / goal, 1)
    }

    var hydrationByDay: [String: Int] {
        store.hydrationTotalsByDay()
    }

    var sleepByDay: [String: Double] {
        store.sleepTotalsByDay()
    }

    var sleepQualityBreakdown: [SleepQuality: Int] {
        store.sleepQualityBreakdown()
    }

    func updateGoals(hydrationGoalMl: Int, sleepGoalHours: Double) {
        store.updateSettings(hydrationGoalMl: hydrationGoalMl, sleepGoalHours: sleepGoalHours)
    }

    func hydrationSummaryLines(limit: Int) -> [String] {
        summaryLines(from: hydrationByDay, limit: limit) { "\($0) ml" }
    }

    func sleepSummaryLines(limit: Int) -> [String] {
        summaryLines(from: sleepByDay, limit: limit) { "\($0.oneDecimalString()) h" }
    }

    func qualitySummaryLine() -> String {
        guard !sleepQualityBreakdown.isEmpty else {
            return "Calidad: sin registros."
        }

        let high = sleepQualityBreakdown[.high, default: 0]
        let medium = sleepQualityBreakdown[.medium, default: 0]
        let low = sleepQualityBreakdown[.low, default: 0]
        return "Calidad: Alta \(high) · Media \(medium) · Baja \(low)"
    }

    private func summaryLines<T>(from dictionary: [String: T], limit: Int, valueFormatter: (T) -> String) -> [String] {
        let keys = dictionary.keys.sorted(by: >).prefix(limit)
        return keys.map { key in
            let label = dayLabel(from: key)
            let value = dictionary[key]!
            return "\(label): \(valueFormatter(value))"
        }
    }

    private func dayLabel(from key: String) -> String {
        if let date = SettingsViewModel.dayFormatter.date(from: key) {
            return SettingsViewModel.displayFormatter.string(from: date)
        }
        return key
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()
}

private extension Double {
    func oneDecimalString() -> String {
        String(format: "%.1f", self)
    }
}
