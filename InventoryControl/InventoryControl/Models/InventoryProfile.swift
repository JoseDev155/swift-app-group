//
//  InventoryProfile.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct InventoryProfile: Codable {
    var businessName: String
    var managerName: String
    var defaultMinStock: Int

    static let defaultValue = InventoryProfile(businessName: "Mi Negocio", managerName: "Encargado", defaultMinStock: 5)
}
