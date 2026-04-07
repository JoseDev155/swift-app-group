//
//  PriceSummaryViewModel.swift
//  PriceMonitor
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class PriceSummaryViewModel {
    private let store: PriceStoreProtocol

    init(store: PriceStoreProtocol = PriceStore.shared) {
        self.store = store
    }

    var totalCount: Int {
        store.prices.count
    }

    func currencySummaryText() -> String {
        let summary = store.pricesByCurrencyCount()
        guard !summary.isEmpty else {
            return "Monedas: sin registros."
        }

        let lines = summary
            .sorted { $0.key < $1.key }
            .map { "\($0.key): \($0.value)" }

        return "Monedas:\n" + lines.joined(separator: "\n")
    }

    func averageSummaryText() -> String {
        let summary = store.averageByCurrency()
        guard !summary.isEmpty else {
            return "Promedios: sin registros."
        }

        let lines = summary
            .sorted { $0.key < $1.key }
            .map { key, value in
                "\(key): \(String(format: "%.2f", value))"
            }

        return "Promedios:\n" + lines.joined(separator: "\n")
    }

    func lastUpdateText() -> String {
        guard let lastDate = store.prices.map({ $0.updatedAt }).max() else {
            return "Última actualización: sin datos."
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return "Última actualización: \(formatter.string(from: lastDate))"
    }
}
