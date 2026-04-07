//
//  Notifications.swift
//  DailyHabitTracker
//
//  Created by Jose Ramos on 6/4/26.
//

import Foundation

enum HabitNotifications {
    static let completionDidChange = Notification.Name("HabitCompletionDidChange")
    static let habitsDidChange = Notification.Name("HabitsDidChange")
}
