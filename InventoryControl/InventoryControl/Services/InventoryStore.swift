//
//  InventoryStore.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

protocol InventoryStoreProtocol {
    var items: [InventoryItem] { get }
    var profile: InventoryProfile { get }

    func addItem(name: String, aisle: String, section: String, stock: Int, minStock: Int, note: String) -> InventoryItem
    func updateItem(id: String, name: String, aisle: String, section: String, stock: Int, minStock: Int, note: String)
    func deleteItem(id: String)
    func updateProfile(businessName: String, managerName: String, defaultMinStock: Int)

    func groupedByAisleAndSection() -> [String: [String: [InventoryItem]]]
    func lowStockCount() -> Int
}

final class InventoryStore: InventoryStoreProtocol {
    static let shared = InventoryStore()

    private let defaults: UserDefaults
    private static let itemsKey = "InventoryControl.items"
    private static let profileKey = "InventoryControl.profile"

    private(set) var items: [InventoryItem]
    private(set) var profile: InventoryProfile

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.items = InventoryStore.loadItems(defaults: defaults)
        self.profile = InventoryStore.loadProfile(defaults: defaults)
    }

    func addItem(name: String, aisle: String, section: String, stock: Int, minStock: Int, note: String) -> InventoryItem {
        let item = InventoryItem(
            id: UUID().uuidString,
            name: name,
            aisle: aisle,
            section: section,
            stock: stock,
            minStock: minStock,
            note: note,
            updatedAt: Date()
        )
        items.insert(item, at: 0)
        saveItems()
        notifyInventoryChanged()
        return item
    }

    func updateItem(id: String, name: String, aisle: String, section: String, stock: Int, minStock: Int, note: String) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        let current = items[index]
        items[index] = InventoryItem(
            id: current.id,
            name: name,
            aisle: aisle,
            section: section,
            stock: stock,
            minStock: minStock,
            note: note,
            updatedAt: Date()
        )
        saveItems()
        notifyInventoryChanged()
    }

    func deleteItem(id: String) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items.remove(at: index)
        saveItems()
        notifyInventoryChanged()
    }

    func updateProfile(businessName: String, managerName: String, defaultMinStock: Int) {
        profile = InventoryProfile(businessName: businessName, managerName: managerName, defaultMinStock: defaultMinStock)
        saveProfile()
        NotificationCenter.default.post(name: InventoryNotifications.profileDidChange, object: nil)
    }

    func groupedByAisleAndSection() -> [String: [String: [InventoryItem]]] {
        var grouped: [String: [String: [InventoryItem]]] = [:]
        for item in items {
            var sectionMap = grouped[item.aisle, default: [:]]
            var list = sectionMap[item.section, default: []]
            list.append(item)
            sectionMap[item.section] = list
            grouped[item.aisle] = sectionMap
        }
        return grouped
    }

    func lowStockCount() -> Int {
        items.filter { $0.isLowStock }.count
    }

    private func saveItems() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: InventoryStore.itemsKey)
    }

    private func saveProfile() {
        guard let data = try? JSONEncoder().encode(profile) else { return }
        defaults.set(data, forKey: InventoryStore.profileKey)
    }

    private func notifyInventoryChanged() {
        NotificationCenter.default.post(name: InventoryNotifications.inventoryDidChange, object: nil)
    }

    private static func loadItems(defaults: UserDefaults) -> [InventoryItem] {
        if let data = defaults.data(forKey: InventoryStore.itemsKey),
           let stored = try? JSONDecoder().decode([InventoryItem].self, from: data) {
            return stored
        }
        return []
    }

    private static func loadProfile(defaults: UserDefaults) -> InventoryProfile {
        if let data = defaults.data(forKey: InventoryStore.profileKey),
           let stored = try? JSONDecoder().decode(InventoryProfile.self, from: data) {
            return stored
        }
        return InventoryProfile.defaultValue
    }
}
