//
//  Notifications.swift
//  PersonalBudgetManager
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum BudgetNotifications {
    static let entriesDidChange = Notification.Name("BudgetEntriesDidChange")
    static let limitDidChange = Notification.Name("BudgetLimitDidChange")
}
