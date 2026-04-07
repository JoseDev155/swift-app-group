import Foundation

struct YearSummaryItem {
    let year: String
    let count: Int
}

struct TravelSummary {
    let totalEntries: Int
    let uniqueCountries: Int
}

final class TravelSummaryViewModel {
    private let store: TravelStoreProtocol

    init(store: TravelStoreProtocol = TravelStore.shared) {
        self.store = store
    }

    func summary() -> TravelSummary {
        let total = store.entries.count
        let countries = Set(store.entries.map { $0.country }).count
        return TravelSummary(totalEntries: total, uniqueCountries: countries)
    }

    func yearSummary() -> [YearSummaryItem] {
        var counts: [String: Int] = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"

        for entry in store.entries {
            let year = formatter.string(from: entry.date)
            counts[year, default: 0] += 1
        }

        return counts
            .map { YearSummaryItem(year: $0.key, count: $0.value) }
            .sorted { $0.year > $1.year }
    }
}
