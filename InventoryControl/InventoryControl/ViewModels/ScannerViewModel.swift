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
    case added(InventoryItem)
    case updated(InventoryItem)
    case notFound
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

    func simulateScan(productId: String?, customName: String?) -> ScanResult {
        if let productId = productId, !productId.isEmpty {
            guard let item = store.items.first(where: { $0.id == productId }) else {
                return .notFound
            }

            let newStock = item.stock + 1
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
            return .updated(updatedItem)
        }

        let names = ["Cajas", "Bebidas", "Detergente", "Café", "Galletas", "Cuadernos", "Papel", "Lámparas"]
        let aisles = Array(Set(store.items.map { $0.aisle })).sorted()

        guard let aisle = aisles.randomElement() else {
            return .notFound
        }

        let sections = Array(Set(store.items.filter { $0.aisle == aisle }.map { $0.section })).sorted()
        let section = sections.randomElement() ?? "1"

        let name = (customName?.isEmpty == false ? customName! : names.randomElement()!)
        let stock = Int.random(in: 1...20)
        let minStock = max(1, store.profile.defaultMinStock)

        let item = store.addItem(name: name, aisle: aisle, section: section, stock: stock, minStock: minStock, note: "Escaneo rápido")
        return .added(item)
    }
}
