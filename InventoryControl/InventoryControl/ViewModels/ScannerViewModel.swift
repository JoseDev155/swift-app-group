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
    case outOfStock(InventoryItem)
}

final class ScannerViewModel {
    private let store: InventoryStoreProtocol

    init(store: InventoryStoreProtocol = InventoryStore.shared) {
        self.store = store
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

        guard item.stock > 0 else {
            return .outOfStock(item)
        }

        let requested = (requestedUnits ?? Int.random(in: 1...50))
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

        return .purchased(item: updatedItem, requested: requested, delivered: delivered)
    }
}
