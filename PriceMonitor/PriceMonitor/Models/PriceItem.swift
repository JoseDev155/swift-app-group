//
//  PriceItem.swift
//  PriceMonitor
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct PriceItem: Hashable, Codable {
    let id: String
    let name: String
    let currencyCode: String
    let value: Double
    let previousValue: Double
    let updatedAt: Date
    let note: String
}

extension PriceItem {
    var changeValue: Double {
        value - previousValue
    }

    var isUp: Bool {
        changeValue > 0
    }

    var valueText: String {
        String(format: "%.2f", value)
    }

    var changeText: String {
        if changeValue == 0 {
            return "Sin cambio"
        }
        let sign = changeValue > 0 ? "+" : ""
        return sign + String(format: "%.2f", changeValue)
    }
}

extension Date {
    private static let priceTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()

    func priceTimeLabel() -> String {
        Date.priceTimeFormatter.string(from: self)
    }
}
