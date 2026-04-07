//
//  InventoryListViewModel.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class InventoryListViewModel {
    private let store: InventoryStoreProtocol

    init(store: InventoryStoreProtocol = InventoryStore.shared) {
        self.store = store
    }

    var items: [InventoryItem] {
        store.items.sorted { $0.updatedAt > $1.updatedAt }
    }

    var totalCount: Int {
        store.items.count
    }

    var lowStockCount: Int {
        store.lowStockCount()
    }

    func item(at index: Int) -> InventoryItem {
        items[index]
    }

    func addItem(name: String, aisle: String, section: String, stock: Int, minStock: Int, note: String) {
        _ = store.addItem(name: name, aisle: aisle, section: section, stock: stock, minStock: minStock, note: note)
    }

    func updateItem(id: String, name: String, aisle: String, section: String, stock: Int, minStock: Int, note: String) {
        store.updateItem(id: id, name: name, aisle: aisle, section: section, stock: stock, minStock: minStock, note: note)
    }

    func deleteItem(id: String) {
        store.deleteItem(id: id)
    }
}
