import Foundation

protocol HabitStoreProtocol {
    var habits: [Habit] { get }
    func isCompleted(_ habit: Habit, on date: Date) -> Bool
    func setCompleted(_ completed: Bool, for habit: Habit, on date: Date)
    func completionSummary(on date: Date) -> (completed: Int, total: Int)
}

final class HabitStore: HabitStoreProtocol {
    static let shared = HabitStore()

    private let defaults: UserDefaults
    private let completionKey = "HabitCompletionByDate"

    let habits: [Habit] = [
        Habit(id: "drink_water", title: "Beber agua", detail: "8 vasos"),
        Habit(id: "walk_steps", title: "Caminar", detail: "6000 pasos"),
        Habit(id: "read_pages", title: "Leer", detail: "15 paginas"),
        Habit(id: "sleep_hours", title: "Dormir", detail: "7 horas"),
        Habit(id: "stretch", title: "Estirar", detail: "5 minutos")
    ]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
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

    private func dateKey(for date: Date) -> String {
        HabitStore.dateFormatter.string(from: date)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
