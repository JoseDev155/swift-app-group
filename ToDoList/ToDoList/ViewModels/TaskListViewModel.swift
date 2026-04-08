//
//  TaskListViewModel.swift
//  ToDoList
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class TaskListViewModel {
    private let store: TaskStoreProtocol

    init(store: TaskStoreProtocol = TaskStore.shared) {
        self.store = store
    }

    var tasks: [TaskItem] {
        store.tasks
    }

    func task(at index: Int) -> TaskItem {
        tasks[index]
    }

    func addTask(title: String, detail: String, priority: TaskPriority, dueDate: Date) {
        _ = store.addTask(title: title, detail: detail, priority: priority, dueDate: dueDate)
    }

    func updateTask(at index: Int, title: String, detail: String, priority: TaskPriority, dueDate: Date) {
        let task = tasks[index]
        store.updateTask(id: task.id, title: title, detail: detail, priority: priority, dueDate: dueDate)
    }

    func deleteTask(at index: Int) {
        let task = tasks[index]
        store.deleteTask(id: task.id)
    }

    func toggleCompletion(at index: Int) {
        let task = tasks[index]
        store.toggleCompletion(id: task.id)
    }

    func refreshExpiredTasks(currentDate: Date) {
        _ = store.refreshExpiredTasks(currentDate: currentDate)
    }
}
