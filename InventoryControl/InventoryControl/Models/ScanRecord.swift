//
//  ScanRecord.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct ScanRecord: Hashable, Codable {
    let id: String
    let itemId: String
    let itemName: String
    let aisle: String
    let section: String
    let requested: Int
    let delivered: Int
    let createdAt: Date
}

extension ScanRecord {
    var locationText: String {
        "Pasillo \(aisle) · Sección \(section)"
    }

    var quantityText: String {
        "Solicitadas: \(requested) · Entregadas: \(delivered)"
    }
}
