//
//  InventoryItem.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct InventoryItem: Hashable, Codable {
    let id: String
    let name: String
    let aisle: String
    let section: String
    let stock: Int
    let minStock: Int
    let note: String
    let updatedAt: Date
}

extension InventoryItem {
    var isLowStock: Bool {
        stock <= minStock
    }

    var locationText: String {
        "Pasillo \(aisle) · Sección \(section)"
    }

    var stockText: String {
        "\(stock) uds · Mínimo \(minStock)"
    }
}

extension Date {
    private static let inventoryTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()

    func inventoryTimeLabel() -> String {
        Date.inventoryTimeFormatter.string(from: self)
    }
}
