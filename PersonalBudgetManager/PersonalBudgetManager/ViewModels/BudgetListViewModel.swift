import Foundation

final class BudgetListViewModel {
    private let store: BudgetStoreProtocol

    init(store: BudgetStoreProtocol = BudgetStore.shared) {
        self.store = store
    }

    var entries: [BudgetEntry] {
        store.entries
    }

    var monthlyLimit: Double {
        store.monthlyLimit
    }

    func entry(at index: Int) -> BudgetEntry {
        entries[index]
    }

    func addEntry(title: String, amount: Double, category: String, type: EntryType) -> BudgetEntry {
        store.addEntry(title: title, amount: amount, category: category, type: type)
    }

    func updateEntry(at index: Int, title: String, amount: Double, category: String, type: EntryType) {
        let entry = entries[index]
        store.updateEntry(id: entry.id, title: title, amount: amount, category: category, type: type)
    }

    func deleteEntry(at index: Int) {
        let entry = entries[index]
        store.deleteEntry(id: entry.id)
    }

    func setMonthlyLimit(_ limit: Double) {
        store.setMonthlyLimit(limit)
    }

    func total(for type: EntryType) -> Double {
        store.total(for: type)
    }

    func exceedsLimit() -> Bool {
        total(for: .expense) > monthlyLimit
    }
}
