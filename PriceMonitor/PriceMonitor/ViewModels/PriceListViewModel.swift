//
//  PriceListViewModel.swift
//  PriceMonitor
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class PriceListViewModel {
    private let store: PriceStoreProtocol

    init(store: PriceStoreProtocol = PriceStore.shared) {
        self.store = store
    }

    var prices: [PriceItem] {
        store.prices.sorted { $0.updatedAt > $1.updatedAt }
    }

    func price(at index: Int) -> PriceItem {
        prices[index]
    }

    func addPrice(name: String, currencyCode: String, value: Double, note: String) {
        _ = store.addPrice(name: name, currencyCode: currencyCode, value: value, note: note)
    }

    func updatePrice(id: String, name: String, currencyCode: String, value: Double, note: String) {
        store.updatePrice(id: id, name: name, currencyCode: currencyCode, value: value, note: note)
    }

    func deletePrice(id: String) {
        store.deletePrice(id: id)
    }

    func simulatePrices() {
        store.simulatePrices()
    }
}
