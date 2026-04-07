import Foundation

final class TravelListViewModel {
    private let store: TravelStoreProtocol

    init(store: TravelStoreProtocol = TravelStore.shared) {
        self.store = store
    }

    var entries: [TravelEntry] {
        store.entries.sorted { $0.date > $1.date }
    }

    func entry(at index: Int) -> TravelEntry {
        entries[index]
    }

    func addEntry(country: String, city: String, notes: String, date: Date) {
        store.addEntry(country: country, city: city, notes: notes, date: date)
    }

    func updateEntry(at index: Int, country: String, city: String, notes: String, date: Date) {
        let entry = entries[index]
        store.updateEntry(id: entry.id, country: country, city: city, notes: notes, date: date)
    }

    func deleteEntry(at index: Int) {
        let entry = entries[index]
        store.deleteEntry(id: entry.id)
    }
}
