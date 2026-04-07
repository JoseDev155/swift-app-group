//
//  HabitStore.swift
//  DailyHabitTracker
//
//  Created by Jose Ramos on 6/4/26.
//

import Foundation

protocol HabitStoreProtocol {
    var habits: [Habit] { get }
    func isCompleted(_ habit: Habit, on date: Date) -> Bool
    func setCompleted(_ completed: Bool, for habit: Habit, on date: Date)
    func completionSummary(on date: Date) -> (completed: Int, total: Int)
    func addHabit(title: String, detail: String) -> Habit
    func updateHabit(id: String, title: String, detail: String)
    func deleteHabit(id: String)
}

final class HabitStore: HabitStoreProtocol {
    static let shared = HabitStore()

    private let defaults: UserDefaults
    private let completionKey = "HabitCompletionByDate"
    private static let habitsKey = "HabitsList"

    private(set) var habits: [Habit]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.habits = HabitStore.loadHabits(defaults: defaults)
    }

    func isCompleted(_ habit: Habit, on date: Date) -> Bool {
        let key = dateKey(for: date)
        let dayCompletion = completionByDate()[key] ?? [:]
        return dayCompletion[habit.id] ?? false
    }

    func setCompleted(_ completed: Bool, for habit: Habit, on date: Date) {
        let key = dateKey(for: date)
        var allCompletion = completionByDate()
        var dayCompletion = allCompletion[key] ?? [:]
        dayCompletion[habit.id] = completed
        allCompletion[key] = dayCompletion
        saveCompletion(allCompletion)

        NotificationCenter.default.post(name: HabitNotifications.completionDidChange, object: nil)
    }

    func completionSummary(on date: Date) -> (completed: Int, total: Int) {
        let key = dateKey(for: date)
        let dayCompletion = completionByDate()[key] ?? [:]
        let completedCount = habits.filter { dayCompletion[$0.id] == true }.count
        return (completedCount, habits.count)
    }

    func addHabit(title: String, detail: String) -> Habit {
        let habit = Habit(id: UUID().uuidString, title: title, detail: detail)
        habits.append(habit)
        saveHabits()
        notifyHabitsChanged()
        return habit
    }

    func updateHabit(id: String, title: String, detail: String) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index] = Habit(id: id, title: title, detail: detail)
        saveHabits()
        notifyHabitsChanged()
    }

    func deleteHabit(id: String) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits.remove(at: index)
        removeCompletion(for: id)
        saveHabits()
        notifyHabitsChanged()
    }

    private func completionByDate() -> [String: [String: Bool]] {
        let raw = defaults.dictionary(forKey: completionKey) ?? [:]
        var result: [String: [String: Bool]] = [:]
        for (dateKey, value) in raw {
            if let dayCompletion = value as? [String: Bool] {
                result[dateKey] = dayCompletion
            }
        }
        return result
    }

    private func saveCompletion(_ data: [String: [String: Bool]]) {
        defaults.set(data, forKey: completionKey)
    }

    private func removeCompletion(for habitId: String) {
        var allCompletion = completionByDate()
        for (dateKey, value) in allCompletion {
            var dayCompletion = value
            dayCompletion.removeValue(forKey: habitId)
            allCompletion[dateKey] = dayCompletion
        }
        saveCompletion(allCompletion)
    }

    private func notifyHabitsChanged() {
        NotificationCenter.default.post(name: HabitNotifications.habitsDidChange, object: nil)
    }

    private func saveHabits() {
        guard let data = try? JSONEncoder().encode(habits) else { return }
        defaults.set(data, forKey: HabitStore.habitsKey)
    }

    private static func loadHabits(defaults: UserDefaults) -> [Habit] {
        if let data = defaults.data(forKey: HabitStore.habitsKey),
           let stored = try? JSONDecoder().decode([Habit].self, from: data) {
            return stored
        }
        return defaultHabits
    }

    private func dateKey(for date: Date) -> String {
        HabitStore.dateFormatter.string(from: date)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let defaultHabits: [Habit] = [
        Habit(id: "example1", title: "Ejemplo 1", detail: "Soy un hábito diario por defecto, no me borres por favor :("),
        Habit(id: "example2", title: "Caminar", detail: "6000 pasos")
    ]
}
