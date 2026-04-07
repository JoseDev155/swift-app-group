//
//  HabitsListViewModel.swift
//  DailyHabitTracker
//
//  Created by Jose Ramos on 6/4/26.
//

import Foundation

final class HabitsListViewModel {
    private let store: HabitStoreProtocol
    private let dateProvider: () -> Date

    init(store: HabitStoreProtocol = HabitStore.shared, dateProvider: @escaping () -> Date = Date.init) {
        self.store = store
        self.dateProvider = dateProvider
    }

    var habits: [Habit] {
        store.habits
    }

    func habit(at index: Int) -> Habit {
        habits[index]
    }

    func isCompleted(at index: Int) -> Bool {
        store.isCompleted(habits[index], on: dateProvider())
    }

    @discardableResult
    func addHabit(title: String, detail: String) -> Habit {
        store.addHabit(title: title, detail: detail)
    }

    func updateHabit(at index: Int, title: String, detail: String) {
        let habit = habits[index]
        store.updateHabit(id: habit.id, title: title, detail: detail)
    }

    func deleteHabit(at index: Int) {
        let habit = habits[index]
        store.deleteHabit(id: habit.id)
    }

    @discardableResult
    func toggleCompletion(at index: Int) -> Bool {
        let habit = habits[index]
        let current = store.isCompleted(habit, on: dateProvider())
        let next = !current
        store.setCompleted(next, for: habit, on: dateProvider())
        return next
    }
}
