//
//  HydrationSleepSettings.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct HydrationSleepSettings: Codable {
    var hydrationGoalMl: Int
    var sleepGoalHours: Double

    static let defaultValue = HydrationSleepSettings(hydrationGoalMl: 2000, sleepGoalHours: 8)
}
