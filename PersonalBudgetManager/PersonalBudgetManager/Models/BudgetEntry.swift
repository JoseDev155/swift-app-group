import Foundation

enum EntryType: String, Codable, CaseIterable {
    case expense
    case income

    var title: String {
        switch self {
        case .expense:
            return "Gasto"
        case .income:
            return "Ingreso"
        }
    }

    var sign: String {
        switch self {
        case .expense:
            return "-"
        case .income:
            return "+"
        }
    }
}

struct BudgetEntry: Hashable, Codable {
    let id: String
    let title: String
    let amount: Double
    let category: String
    let type: EntryType
    let date: Date
}
