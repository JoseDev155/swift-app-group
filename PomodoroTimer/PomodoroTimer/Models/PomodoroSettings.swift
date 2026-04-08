//
//  PomodoroSettings.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

struct PomodoroSettings: Codable {
    var workMinutes: Int
    var shortBreakMinutes: Int
    var longBreakMinutes: Int

    static let defaultValue = PomodoroSettings(workMinutes: 25, shortBreakMinutes: 5, longBreakMinutes: 15)
}
