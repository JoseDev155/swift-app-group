//
//  TaskItem.swift
//  ToDoList
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum TaskPriority: String, Codable, CaseIterable {
    case high
    case medium
    case low

    var title: String {
        switch self {
        case .high:
            return "Alta"
        case .medium:
            return "Media"
        case .low:
            return "Baja"
        }
    }

    var sortOrder: Int {
        switch self {
        case .high:
            return 0
        case .medium:
            return 1
        case .low:
            return 2
        }
    }
}

struct TaskItem: Hashable, Codable {
    let id: String
    let title: String
    let detail: String
    let priority: TaskPriority
    let dueDate: Date
    let isCompleted: Bool
    let isExpired: Bool
}
