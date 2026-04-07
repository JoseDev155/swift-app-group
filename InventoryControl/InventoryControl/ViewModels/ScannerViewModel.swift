//
//  ScannerViewModel.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class ScannerViewModel {
    private let store: InventoryStoreProtocol

    init(store: InventoryStoreProtocol = InventoryStore.shared) {
        self.store = store
    }

    func simulateScan(customName: String?) -> InventoryItem {
        let names = ["Cajas", "Bebidas", "Detergente", "Café", "Galletas", "Cuadernos", "Papel", "Lámparas"]
        let aisles = ["A", "B", "C", "D"]
        let sections = ["1", "2", "3"]

        let name = (customName?.isEmpty == false ? customName! : names.randomElement()!)
        let aisle = aisles.randomElement()!
        let section = sections.randomElement()!
        let stock = Int.random(in: 1...20)
        let minStock = max(1, store.profile.defaultMinStock)

        return store.addItem(name: name, aisle: aisle, section: section, stock: stock, minStock: minStock, note: "Escaneo rápido")
    }
}
