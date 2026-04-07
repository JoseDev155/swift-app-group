//
//  HydrationSleepStore.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

protocol HydrationSleepStoreProtocol {
    var waterEntries: [WaterEntry] { get }
    var sleepEntries: [SleepEntry] { get }
    var settings: HydrationSleepSettings { get }

    func addWaterEntry(milliliters: Int, note: String) -> WaterEntry
    func updateWaterEntry(id: String, milliliters: Int, note: String)
    func deleteWaterEntry(id: String)

    func addSleepEntry(hours: Double, quality: SleepQuality, note: String) -> SleepEntry
    func updateSleepEntry(id: String, hours: Double, quality: SleepQuality, note: String)
    func deleteSleepEntry(id: String)

    func updateSettings(hydrationGoalMl: Int, sleepGoalHours: Double)

    func hydrationTotalsByDay() -> [String: Int]
    func sleepTotalsByDay() -> [String: Double]
    func sleepQualityBreakdown() -> [SleepQuality: Int]

    func hydrationTotal(for date: Date) -> Int
    func sleepTotal(for date: Date) -> Double
}

final class HydrationSleepStore: HydrationSleepStoreProtocol {
    static let shared = HydrationSleepStore()

    private let defaults: UserDefaults
    private static let waterKey = "HydrationSleep.waterEntries"
    private static let sleepKey = "HydrationSleep.sleepEntries"
    private static let settingsKey = "HydrationSleep.settings"

    private(set) var waterEntries: [WaterEntry]
    private(set) var sleepEntries: [SleepEntry]
    private(set) var settings: HydrationSleepSettings

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.waterEntries = HydrationSleepStore.loadWaterEntries(defaults: defaults)
        self.sleepEntries = HydrationSleepStore.loadSleepEntries(defaults: defaults)
        self.settings = HydrationSleepStore.loadSettings(defaults: defaults)
    }

    func addWaterEntry(milliliters: Int, note: String) -> WaterEntry {
        let entry = WaterEntry(
            id: UUID().uuidString,
            date: Date(),
            milliliters: milliliters,
            note: note
        )
        waterEntries.insert(entry, at: 0)
        saveWaterEntries()
        notifyWaterChanged()
        return entry
    }

    func updateWaterEntry(id: String, milliliters: Int, note: String) {
        guard let index = waterEntries.firstIndex(where: { $0.id == id }) else { return }
        let current = waterEntries[index]
        waterEntries[index] = WaterEntry(
            id: current.id,
            date: current.date,
            milliliters: milliliters,
            note: note
        )
        saveWaterEntries()
        notifyWaterChanged()
    }

    func deleteWaterEntry(id: String) {
        guard let index = waterEntries.firstIndex(where: { $0.id == id }) else { return }
        waterEntries.remove(at: index)
        saveWaterEntries()
        notifyWaterChanged()
    }

    func addSleepEntry(hours: Double, quality: SleepQuality, note: String) -> SleepEntry {
        let entry = SleepEntry(
            id: UUID().uuidString,
            date: Date(),
            hours: hours,
            quality: quality,
            note: note
        )
        sleepEntries.insert(entry, at: 0)
        saveSleepEntries()
        notifySleepChanged()
        return entry
    }

    func updateSleepEntry(id: String, hours: Double, quality: SleepQuality, note: String) {
        guard let index = sleepEntries.firstIndex(where: { $0.id == id }) else { return }
        let current = sleepEntries[index]
        sleepEntries[index] = SleepEntry(
            id: current.id,
            date: current.date,
            hours: hours,
            quality: quality,
            note: note
        )
        saveSleepEntries()
        notifySleepChanged()
    }

    func deleteSleepEntry(id: String) {
        guard let index = sleepEntries.firstIndex(where: { $0.id == id }) else { return }
        sleepEntries.remove(at: index)
        saveSleepEntries()
        notifySleepChanged()
    }

    func updateSettings(hydrationGoalMl: Int, sleepGoalHours: Double) {
        settings = HydrationSleepSettings(hydrationGoalMl: hydrationGoalMl, sleepGoalHours: sleepGoalHours)
        saveSettings()
        notifySettingsChanged()
    }

    func hydrationTotalsByDay() -> [String: Int] {
        var totals: [String: Int] = [:]
        for entry in waterEntries {
            let key = entry.date.dayKey()
            totals[key, default: 0] += entry.milliliters
        }
        return totals
    }

    func sleepTotalsByDay() -> [String: Double] {
        var totals: [String: Double] = [:]
        for entry in sleepEntries {
            let key = entry.date.dayKey()
            totals[key, default: 0] += entry.hours
        }
        return totals
    }

    func sleepQualityBreakdown() -> [SleepQuality: Int] {
        var totals: [SleepQuality: Int] = [:]
        for entry in sleepEntries {
            totals[entry.quality, default: 0] += 1
        }
        return totals
    }

    func hydrationTotal(for date: Date) -> Int {
        let key = date.dayKey()
        return waterEntries.filter { $0.date.dayKey() == key }.reduce(0) { $0 + $1.milliliters }
    }

    func sleepTotal(for date: Date) -> Double {
        let key = date.dayKey()
        return sleepEntries.filter { $0.date.dayKey() == key }.reduce(0) { $0 + $1.hours }
    }

    private func saveWaterEntries() {
        guard let data = try? JSONEncoder().encode(waterEntries) else { return }
        defaults.set(data, forKey: HydrationSleepStore.waterKey)
    }

    private func saveSleepEntries() {
        guard let data = try? JSONEncoder().encode(sleepEntries) else { return }
        defaults.set(data, forKey: HydrationSleepStore.sleepKey)
    }

    private func saveSettings() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: HydrationSleepStore.settingsKey)
    }

    private func notifyWaterChanged() {
        NotificationCenter.default.post(name: HydrationSleepNotifications.waterDidChange, object: nil)
    }

    private func notifySleepChanged() {
        NotificationCenter.default.post(name: HydrationSleepNotifications.sleepDidChange, object: nil)
    }

    private func notifySettingsChanged() {
        NotificationCenter.default.post(name: HydrationSleepNotifications.settingsDidChange, object: nil)
    }

    private static func loadWaterEntries(defaults: UserDefaults) -> [WaterEntry] {
        if let data = defaults.data(forKey: HydrationSleepStore.waterKey),
           let stored = try? JSONDecoder().decode([WaterEntry].self, from: data) {
            return stored
        }
        return []
    }

    private static func loadSleepEntries(defaults: UserDefaults) -> [SleepEntry] {
        if let data = defaults.data(forKey: HydrationSleepStore.sleepKey),
           let stored = try? JSONDecoder().decode([SleepEntry].self, from: data) {
            return stored
        }
        return []
    }

    private static func loadSettings(defaults: UserDefaults) -> HydrationSleepSettings {
        if let data = defaults.data(forKey: HydrationSleepStore.settingsKey),
           let stored = try? JSONDecoder().decode(HydrationSleepSettings.self, from: data) {
            return stored
        }
        return HydrationSleepSettings.defaultValue
    }
}

extension Date {
    private static let hydrationSleepDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let hydrationSleepTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()

    func dayKey() -> String {
        Date.hydrationSleepDayFormatter.string(from: self)
    }

    func timeLabel() -> String {
        Date.hydrationSleepTimeFormatter.string(from: self)
    }
}
