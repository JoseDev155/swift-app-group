//
//  Notifications.swift
//  ToDoList
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum TaskNotifications {
    static let tasksDidChange = Notification.Name("TasksDidChange")
    static let taskExpiryDidChange = Notification.Name("TaskExpiryDidChange")
}
