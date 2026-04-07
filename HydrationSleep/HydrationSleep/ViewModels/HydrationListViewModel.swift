//
//  HydrationListViewModel.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class HydrationListViewModel {
    private let store: HydrationSleepStoreProtocol

    init(store: HydrationSleepStoreProtocol = HydrationSleepStore.shared) {
        self.store = store
    }

    var entries: [WaterEntry] {
        store.waterEntries
    }

    var hydrationGoal: Int {
        store.settings.hydrationGoalMl
    }

    var todayTotal: Int {
        store.hydrationTotal(for: Date())
    }

    var progress: Double {
        let goal = max(hydrationGoal, 1)
        return min(Double(todayTotal) / Double(goal), 1)
    }

    var totalsByDay: [String: Int] {
        store.hydrationTotalsByDay()
    }

    func entry(at index: Int) -> WaterEntry {
        entries[index]
    }

    func addEntry(milliliters: Int, note: String) {
        _ = store.addWaterEntry(milliliters: milliliters, note: note)
    }

    func updateEntry(id: String, milliliters: Int, note: String) {
        store.updateWaterEntry(id: id, milliliters: milliliters, note: note)
    }

    func deleteEntry(id: String) {
        store.deleteWaterEntry(id: id)
    }
}
