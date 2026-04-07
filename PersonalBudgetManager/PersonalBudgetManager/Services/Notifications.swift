import Foundation

enum BudgetNotifications {
    static let entriesDidChange = Notification.Name("BudgetEntriesDidChange")
    static let limitDidChange = Notification.Name("BudgetLimitDidChange")
}
