import Foundation

struct CategoryTotal {
    let category: String
    let total: Double
}

struct ReportSummary {
    let income: Double
    let expense: Double
    let balance: Double
}

final class ReportsViewModel {
    private let store: BudgetStoreProtocol

    init(store: BudgetStoreProtocol = BudgetStore.shared) {
        self.store = store
    }

    func summary() -> ReportSummary {
        let income = store.total(for: .income)
        let expense = store.total(for: .expense)
        return ReportSummary(income: income, expense: expense, balance: income - expense)
    }

    func categoryTotals() -> [CategoryTotal] {
        var totals: [String: Double] = [:]
        for entry in store.entries where entry.type == .expense {
            totals[entry.category, default: 0] += entry.amount
        }
        return totals
            .map { CategoryTotal(category: $0.key, total: $0.value) }
            .sorted { $0.total > $1.total }
    }
}
