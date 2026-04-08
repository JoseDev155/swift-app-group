//
//  Notifications.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum PomodoroNotifications {
    static let sessionsDidChange = Notification.Name("PomodoroTimer.sessionsDidChange")
    static let settingsDidChange = Notification.Name("PomodoroTimer.settingsDidChange")
}
