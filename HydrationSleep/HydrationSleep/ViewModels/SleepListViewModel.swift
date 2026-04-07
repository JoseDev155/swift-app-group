//
//  SleepListViewModel.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class SleepListViewModel {
    private let store: HydrationSleepStoreProtocol

    init(store: HydrationSleepStoreProtocol = HydrationSleepStore.shared) {
        self.store = store
    }

    var entries: [SleepEntry] {
        store.sleepEntries
    }

    var sleepGoal: Double {
        store.settings.sleepGoalHours
    }

    var todayTotal: Double {
        store.sleepTotal(for: Date())
    }

    var progress: Double {
        let goal = max(sleepGoal, 0.1)
        return min(todayTotal / goal, 1)
    }

    var totalsByDay: [String: Double] {
        store.sleepTotalsByDay()
    }

    func entry(at index: Int) -> SleepEntry {
        entries[index]
    }

    func addEntry(hours: Double, quality: SleepQuality, note: String) {
        _ = store.addSleepEntry(hours: hours, quality: quality, note: note)
    }

    func updateEntry(id: String, hours: Double, quality: SleepQuality, note: String) {
        store.updateSleepEntry(id: id, hours: hours, quality: quality, note: note)
    }

    func deleteEntry(id: String) {
        store.deleteSleepEntry(id: id)
    }
}
