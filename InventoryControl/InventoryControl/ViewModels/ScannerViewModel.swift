//
//  ScannerViewModel.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum ScanAvailability {
    case available
    case noInventory
    case noStock
}

enum ScanResult {
    case purchased(item: InventoryItem, requested: Int, delivered: Int)
    case notFound
    case outOfStock(item: InventoryItem, requested: Int)
}

final class ScannerViewModel {
    private let store: InventoryStoreProtocol
    private let historyStore: ScanHistoryStoreProtocol

    init(store: InventoryStoreProtocol = InventoryStore.shared, historyStore: ScanHistoryStoreProtocol = ScanHistoryStore.shared) {
        self.store = store
        self.historyStore = historyStore
    }

    func scanAvailability() -> ScanAvailability {
        if store.items.isEmpty {
            return .noInventory
        }

        if store.items.allSatisfy({ $0.stock == 0 }) {
            return .noStock
        }

        return .available
    }

    func simulateScan(productId: String?, name: String?, requestedUnits: Int?) -> ScanResult {
        let trimmedId = productId?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimmedName = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let selectedItem: InventoryItem?
        if !trimmedId.isEmpty {
            selectedItem = store.items.first(where: { $0.id == trimmedId })
        } else if !trimmedName.isEmpty {
            selectedItem = store.items.first(where: { $0.name.lowercased() == trimmedName.lowercased() })
        } else {
            selectedItem = store.items.filter { $0.stock > 0 }.randomElement()
        }

        guard let item = selectedItem else {
            return .notFound
        }

        let requested = (requestedUnits ?? Int.random(in: 1...50))

        guard item.stock > 0 else {
            _ = historyStore.addRecord(item: item, requested: requested, delivered: 0)
            return .outOfStock(item: item, requested: requested)
        }

        let delivered = min(requested, item.stock)
        let newStock = max(item.stock - delivered, 0)

        store.updateItem(
            id: item.id,
            name: item.name,
            aisle: item.aisle,
            section: item.section,
            stock: newStock,
            minStock: item.minStock,
            note: item.note
        )

        let updatedItem = InventoryItem(
            id: item.id,
            name: item.name,
            aisle: item.aisle,
            section: item.section,
            stock: newStock,
            minStock: item.minStock,
            note: item.note,
            updatedAt: Date()
        )

        _ = historyStore.addRecord(item: updatedItem, requested: requested, delivered: delivered)
        return .purchased(item: updatedItem, requested: requested, delivered: delivered)
    }
}
