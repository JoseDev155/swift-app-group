//
//  ProfileViewModel.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class ProfileViewModel {
    private let store: InventoryStoreProtocol

    init(store: InventoryStoreProtocol = InventoryStore.shared) {
        self.store = store
    }

    var businessName: String {
        store.profile.businessName
    }

    var managerName: String {
        store.profile.managerName
    }

    var defaultMinStock: Int {
        store.profile.defaultMinStock
    }

    var totalCount: Int {
        store.items.count
    }

    var lowStockCount: Int {
        store.lowStockCount()
    }

    func updateProfile(businessName: String, managerName: String, defaultMinStock: Int) {
        store.updateProfile(businessName: businessName, managerName: managerName, defaultMinStock: defaultMinStock)
    }

    func aisleSummaryText() -> String {
        let grouped = store.groupedByAisleAndSection()
        guard !grouped.isEmpty else {
            return "Pasillos: sin registros."
        }

        let lines = grouped.keys.sorted().map { (aisle: String) -> String in
            let sections = grouped[aisle] ?? [:]
            let sectionDetails: [String] = sections.keys.sorted().map { (section: String) -> String in
                let count = sections[section]?.count ?? 0
                return "Sección \(section) (\(count))"
            }
            let detailText = sectionDetails.joined(separator: ", ")
            return "Pasillo \(aisle): \(detailText)"
        }

        return "Pasillos:\n" + lines.joined(separator: "\n")
    }
}
