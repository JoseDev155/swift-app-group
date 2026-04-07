import Foundation

enum TaskNotifications {
    static let tasksDidChange = Notification.Name("TasksDidChange")
    static let taskExpiryDidChange = Notification.Name("TaskExpiryDidChange")
}
