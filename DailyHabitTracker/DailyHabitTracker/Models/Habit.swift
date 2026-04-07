//
//  Habit.swift
//  DailyHabitTracker
//
//  Created by Jose Ramos on 6/4/26.
//

import Foundation

struct Habit: Hashable, Codable {
    let id: String
    let title: String
    let detail: String
}
