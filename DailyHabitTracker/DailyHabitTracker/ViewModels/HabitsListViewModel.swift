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
    func toggleCompletion(at index: Int) -> Bool {
        let habit = habits[index]
        let current = store.isCompleted(habit, on: dateProvider())
        let next = !current
        store.setCompleted(next, for: habit, on: dateProvider())
        return next
    }
}
