//
//  StatsViewModel.swift
//  DailyHabitTracker
//
//  Created by Jose Ramos on 6/4/26.
//

import Foundation

struct StatsSummary {
    let title: String
    let detail: String
    let progress: Float
}

final class StatsViewModel {
    private let store: HabitStoreProtocol
    private let dateProvider: () -> Date

    init(store: HabitStoreProtocol = HabitStore.shared, dateProvider: @escaping () -> Date = Date.init) {
        self.store = store
        self.dateProvider = dateProvider
    }

    func summary() -> StatsSummary {
        let result = store.completionSummary(on: dateProvider())
        let total = max(result.total, 1)
        let progress = Float(result.completed) / Float(total)
        let detail = "\(result.completed) de \(result.total) completados"
        return StatsSummary(title: "Progreso de hoy", detail: detail, progress: progress)
    }
}
