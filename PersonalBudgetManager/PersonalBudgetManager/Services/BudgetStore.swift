import Foundation

protocol BudgetStoreProtocol {
    var entries: [BudgetEntry] { get }
    var monthlyLimit: Double { get }
    func addEntry(title: String, amount: Double, category: String, type: EntryType) -> BudgetEntry
    func updateEntry(id: String, title: String, amount: Double, category: String, type: EntryType)
    func deleteEntry(id: String)
    func setMonthlyLimit(_ limit: Double)
    func total(for type: EntryType) -> Double
}

final class BudgetStore: BudgetStoreProtocol {
    static let shared = BudgetStore()

    private let defaults: UserDefaults
    private static let entriesKey = "BudgetEntries"
    private static let limitKey = "BudgetMonthlyLimit"

    private(set) var entries: [BudgetEntry]
    private(set) var monthlyLimit: Double

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.entries = BudgetStore.loadEntries(defaults: defaults)
        self.monthlyLimit = BudgetStore.loadLimit(defaults: defaults)
    }

    func addEntry(title: String, amount: Double, category: String, type: EntryType) -> BudgetEntry {
        let entry = BudgetEntry(
            id: UUID().uuidString,
            title: title,
            amount: amount,
            category: category,
            type: type,
            date: Date()
        )
        entries.insert(entry, at: 0)
        saveEntries()
        notifyEntriesChanged()
        return entry
    }

    func updateEntry(id: String, title: String, amount: Double, category: String, type: EntryType) {
        guard let index = entries.firstIndex(where: { $0.id == id }) else { return }
        let current = entries[index]
        entries[index] = BudgetEntry(
            id: current.id,
            title: title,
            amount: amount,
            category: category,
            type: type,
            date: current.date
        )
        saveEntries()
        notifyEntriesChanged()
    }

    func deleteEntry(id: String) {
        guard let index = entries.firstIndex(where: { $0.id == id }) else { return }
        entries.remove(at: index)
        saveEntries()
        notifyEntriesChanged()
    }

    func setMonthlyLimit(_ limit: Double) {
        monthlyLimit = limit
        defaults.set(limit, forKey: BudgetStore.limitKey)
        NotificationCenter.default.post(name: BudgetNotifications.limitDidChange, object: nil)
    }

    func total(for type: EntryType) -> Double {
        entries.filter { $0.type == type }.reduce(0) { $0 + $1.amount }
    }

    private func saveEntries() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        defaults.set(data, forKey: BudgetStore.entriesKey)
    }

    private func notifyEntriesChanged() {
        NotificationCenter.default.post(name: BudgetNotifications.entriesDidChange, object: nil)
    }

    private static func loadEntries(defaults: UserDefaults) -> [BudgetEntry] {
        if let data = defaults.data(forKey: BudgetStore.entriesKey),
           let stored = try? JSONDecoder().decode([BudgetEntry].self, from: data) {
            return stored
        }
        return defaultEntries
    }

    private static func loadLimit(defaults: UserDefaults) -> Double {
        let stored = defaults.double(forKey: BudgetStore.limitKey)
        if stored > 0 {
            return stored
        }
        return 200
    }

    private static let defaultEntries: [BudgetEntry] = [
        BudgetEntry(id: "rent", title: "Renta", amount: 120, category: "Vivienda", type: .expense, date: Date()),
        BudgetEntry(id: "groceries", title: "Supermercado", amount: 45, category: "Alimentos", type: .expense, date: Date())
    ]
}
