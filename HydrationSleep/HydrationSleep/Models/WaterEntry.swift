//
//  WaterEntry.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct WaterEntry: Hashable, Codable {
    let id: String
    let date: Date
    let milliliters: Int
    let note: String
}
