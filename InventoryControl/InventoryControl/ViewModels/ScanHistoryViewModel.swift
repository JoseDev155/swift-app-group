//
//  ScanHistoryViewModel.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class ScanHistoryViewModel {
    private let store: ScanHistoryStoreProtocol

    init(store: ScanHistoryStoreProtocol = ScanHistoryStore.shared) {
        self.store = store
    }

    var records: [ScanRecord] {
        store.records.sorted { $0.createdAt > $1.createdAt }
    }

    var totalCount: Int {
        store.records.count
    }

    func record(at index: Int) -> ScanRecord {
        records[index]
    }

    func clearHistory() {
        store.clearHistory()
    }
}
