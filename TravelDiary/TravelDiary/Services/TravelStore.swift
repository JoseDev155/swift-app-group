import Foundation

protocol TravelStoreProtocol {
    var entries: [TravelEntry] { get }
    var preferences: TravelPreferences { get }
    func addEntry(country: String, city: String, notes: String, date: Date)
    func updateEntry(id: String, country: String, city: String, notes: String, date: Date)
    func deleteEntry(id: String)
    func updatePreferences(distanceUnit: DistanceUnit, currencyCode: String)
}

final class TravelStore: TravelStoreProtocol {
    static let shared = TravelStore()

    private let defaults: UserDefaults
    private static let entriesKey = "TravelEntries"
    private static let preferencesKey = "TravelPreferences"

    private(set) var entries: [TravelEntry]
    private(set) var preferences: TravelPreferences

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.entries = TravelStore.loadEntries(defaults: defaults)
        self.preferences = TravelStore.loadPreferences(defaults: defaults)
    }

    func addEntry(country: String, city: String, notes: String, date: Date) {
        let entry = TravelEntry(
            id: UUID().uuidString,
            country: country,
            city: city,
            notes: notes,
            date: date
        )
        entries.insert(entry, at: 0)
        saveEntries()
        notifyEntriesChanged()
    }

    func updateEntry(id: String, country: String, city: String, notes: String, date: Date) {
        guard let index = entries.firstIndex(where: { $0.id == id }) else { return }
        entries[index] = TravelEntry(id: id, country: country, city: city, notes: notes, date: date)
        saveEntries()
        notifyEntriesChanged()
    }

    func deleteEntry(id: String) {
        guard let index = entries.firstIndex(where: { $0.id == id }) else { return }
        entries.remove(at: index)
        saveEntries()
        notifyEntriesChanged()
    }

    func updatePreferences(distanceUnit: DistanceUnit, currencyCode: String) {
        preferences = TravelPreferences(distanceUnit: distanceUnit, currencyCode: currencyCode)
        savePreferences()
        NotificationCenter.default.post(name: TravelNotifications.preferencesDidChange, object: nil)
    }

    private func notifyEntriesChanged() {
        NotificationCenter.default.post(name: TravelNotifications.entriesDidChange, object: nil)
    }

    private func saveEntries() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        defaults.set(data, forKey: TravelStore.entriesKey)
    }

    private func savePreferences() {
        guard let data = try? JSONEncoder().encode(preferences) else { return }
        defaults.set(data, forKey: TravelStore.preferencesKey)
    }

    private static func loadEntries(defaults: UserDefaults) -> [TravelEntry] {
        if let data = defaults.data(forKey: TravelStore.entriesKey),
           let stored = try? JSONDecoder().decode([TravelEntry].self, from: data) {
            return stored
        }
        return []
    }

    private static func loadPreferences(defaults: UserDefaults) -> TravelPreferences {
        if let data = defaults.data(forKey: TravelStore.preferencesKey),
           let stored = try? JSONDecoder().decode(TravelPreferences.self, from: data) {
            return stored
        }
        return TravelPreferences(distanceUnit: .kilometers, currencyCode: "USD")
    }
}
