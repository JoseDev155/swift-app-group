//
//  PriceStore.swift
//  PriceMonitor
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

protocol PriceStoreProtocol {
    var prices: [PriceItem] { get }
    func addPrice(name: String, currencyCode: String, value: Double, note: String) -> PriceItem
    func updatePrice(id: String, name: String, currencyCode: String, value: Double, note: String)
    func deletePrice(id: String)
    func simulatePrices()
    func pricesByCurrencyCount() -> [String: Int]
    func averageByCurrency() -> [String: Double]
}

final class PriceStore: PriceStoreProtocol {
    static let shared = PriceStore()

    private let defaults: UserDefaults
    private static let pricesKey = "PriceMonitor.prices"

    private(set) var prices: [PriceItem]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.prices = PriceStore.loadPrices(defaults: defaults)
    }

    func addPrice(name: String, currencyCode: String, value: Double, note: String) -> PriceItem {
        let entry = PriceItem(
            id: UUID().uuidString,
            name: name,
            currencyCode: currencyCode.uppercased(),
            value: value,
            previousValue: value,
            updatedAt: Date(),
            note: note
        )
        prices.insert(entry, at: 0)
        savePrices()
        notifyPricesChanged()
        return entry
    }

    func updatePrice(id: String, name: String, currencyCode: String, value: Double, note: String) {
        guard let index = prices.firstIndex(where: { $0.id == id }) else { return }
        let current = prices[index]
        prices[index] = PriceItem(
            id: current.id,
            name: name,
            currencyCode: currencyCode.uppercased(),
            value: value,
            previousValue: current.value,
            updatedAt: Date(),
            note: note
        )
        savePrices()
        notifyPricesChanged()
    }

    func deletePrice(id: String) {
        guard let index = prices.firstIndex(where: { $0.id == id }) else { return }
        prices.remove(at: index)
        savePrices()
        notifyPricesChanged()
    }

    func simulatePrices() {
        let now = Date()
        prices = prices.map { item in
            let change = Double.random(in: -0.05...0.08)
            let newValue = max(0.01, item.value * (1 + change))
            return PriceItem(
                id: item.id,
                name: item.name,
                currencyCode: item.currencyCode,
                value: newValue,
                previousValue: item.value,
                updatedAt: now,
                note: item.note
            )
        }
        savePrices()
        notifyPricesChanged()
    }

    func pricesByCurrencyCount() -> [String: Int] {
        var totals: [String: Int] = [:]
        for item in prices {
            totals[item.currencyCode, default: 0] += 1
        }
        return totals
    }

    func averageByCurrency() -> [String: Double] {
        var totals: [String: Double] = [:]
        var counts: [String: Int] = [:]
        for item in prices {
            totals[item.currencyCode, default: 0] += item.value
            counts[item.currencyCode, default: 0] += 1
        }
        var averages: [String: Double] = [:]
        for (code, total) in totals {
            let count = Double(counts[code, default: 1])
            averages[code] = total / count
        }
        return averages
    }

    private func savePrices() {
        guard let data = try? JSONEncoder().encode(prices) else { return }
        defaults.set(data, forKey: PriceStore.pricesKey)
    }

    private func notifyPricesChanged() {
        NotificationCenter.default.post(name: PriceNotifications.pricesDidChange, object: nil)
    }

    private static func loadPrices(defaults: UserDefaults) -> [PriceItem] {
        if let data = defaults.data(forKey: PriceStore.pricesKey),
           let stored = try? JSONDecoder().decode([PriceItem].self, from: data) {
            return stored
        }
        return []
    }
}
