//
//  Notifications.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum HydrationSleepNotifications {
    static let waterDidChange = Notification.Name("HydrationSleep.waterDidChange")
    static let sleepDidChange = Notification.Name("HydrationSleep.sleepDidChange")
    static let settingsDidChange = Notification.Name("HydrationSleep.settingsDidChange")
}
