//
//  ScanHistoryStore.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

protocol ScanHistoryStoreProtocol {
    var records: [ScanRecord] { get }
    func addRecord(item: InventoryItem, requested: Int, delivered: Int) -> ScanRecord
    func clearHistory()
}

final class ScanHistoryStore: ScanHistoryStoreProtocol {
    static let shared = ScanHistoryStore()

    private let defaults: UserDefaults
    private static let historyKey = "InventoryControl.scanHistory"

    private(set) var records: [ScanRecord]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.records = ScanHistoryStore.loadRecords(defaults: defaults)
    }

    func addRecord(item: InventoryItem, requested: Int, delivered: Int) -> ScanRecord {
        let record = ScanRecord(
            id: UUID().uuidString,
            itemId: item.id,
            itemName: item.name,
            aisle: item.aisle,
            section: item.section,
            requested: requested,
            delivered: delivered,
            createdAt: Date()
        )
        records.insert(record, at: 0)
        saveRecords()
        NotificationCenter.default.post(name: InventoryNotifications.scanHistoryDidChange, object: nil)
        return record
    }

    func clearHistory() {
        records = []
        saveRecords()
        NotificationCenter.default.post(name: InventoryNotifications.scanHistoryDidChange, object: nil)
    }

    private func saveRecords() {
        guard let data = try? JSONEncoder().encode(records) else { return }
        defaults.set(data, forKey: ScanHistoryStore.historyKey)
    }

    private static func loadRecords(defaults: UserDefaults) -> [ScanRecord] {
        if let data = defaults.data(forKey: ScanHistoryStore.historyKey),
           let stored = try? JSONDecoder().decode([ScanRecord].self, from: data) {
            return stored
        }
        return []
    }
}
