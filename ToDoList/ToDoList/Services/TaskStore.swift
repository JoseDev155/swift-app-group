import Foundation

protocol TaskStoreProtocol {
    var tasks: [TaskItem] { get }
    func addTask(title: String, detail: String, priority: TaskPriority, dueDate: Date) -> TaskItem
    func updateTask(id: String, title: String, detail: String, priority: TaskPriority, dueDate: Date)
    func deleteTask(id: String)
    func toggleCompletion(id: String)
    func refreshExpiredTasks(currentDate: Date) -> Bool
}

final class TaskStore: TaskStoreProtocol {
    static let shared = TaskStore()

    private let defaults: UserDefaults
    private static let tasksKey = "TaskItems"

    private(set) var tasks: [TaskItem]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.tasks = TaskStore.loadTasks(defaults: defaults)
    }

    func addTask(title: String, detail: String, priority: TaskPriority, dueDate: Date) -> TaskItem {
        let expired = dueDate < Date()
        let task = TaskItem(
            id: UUID().uuidString,
            title: title,
            detail: detail,
            priority: priority,
            dueDate: dueDate,
            isCompleted: false,
            isExpired: expired
        )
        tasks.insert(task, at: 0)
        saveTasks()
        notifyTasksChanged(expiryChanged: expired)
        return task
    }

    func updateTask(id: String, title: String, detail: String, priority: TaskPriority, dueDate: Date) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        let current = tasks[index]
        let expired = !current.isCompleted && dueDate < Date()
        tasks[index] = TaskItem(
            id: current.id,
            title: title,
            detail: detail,
            priority: priority,
            dueDate: dueDate,
            isCompleted: current.isCompleted,
            isExpired: expired
        )
        saveTasks()
        notifyTasksChanged(expiryChanged: expired != current.isExpired)
    }

    func deleteTask(id: String) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks.remove(at: index)
        saveTasks()
        notifyTasksChanged(expiryChanged: false)
    }

    func toggleCompletion(id: String) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        let current = tasks[index]
        let nextCompleted = !current.isCompleted
        let expired = nextCompleted ? false : (current.dueDate < Date())
        tasks[index] = TaskItem(
            id: current.id,
            title: current.title,
            detail: current.detail,
            priority: current.priority,
            dueDate: current.dueDate,
            isCompleted: nextCompleted,
            isExpired: expired
        )
        saveTasks()
        notifyTasksChanged(expiryChanged: expired != current.isExpired)
    }

    func refreshExpiredTasks(currentDate: Date) -> Bool {
        var changed = false
        for index in tasks.indices {
            let task = tasks[index]
            let shouldExpire = !task.isCompleted && task.dueDate < currentDate
            if shouldExpire != task.isExpired {
                tasks[index] = TaskItem(
                    id: task.id,
                    title: task.title,
                    detail: task.detail,
                    priority: task.priority,
                    dueDate: task.dueDate,
                    isCompleted: task.isCompleted,
                    isExpired: shouldExpire
                )
                changed = true
            }
        }

        if changed {
            saveTasks()
            notifyTasksChanged(expiryChanged: true)
        }

        return changed
    }

    private func saveTasks() {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        defaults.set(data, forKey: TaskStore.tasksKey)
    }

    private func notifyTasksChanged(expiryChanged: Bool) {
        NotificationCenter.default.post(name: TaskNotifications.tasksDidChange, object: nil)
        if expiryChanged {
            NotificationCenter.default.post(name: TaskNotifications.taskExpiryDidChange, object: nil)
        }
    }

    private static func loadTasks(defaults: UserDefaults) -> [TaskItem] {
        if let data = defaults.data(forKey: TaskStore.tasksKey),
           let stored = try? JSONDecoder().decode([TaskItem].self, from: data) {
            return stored
        }
        return []
    }
}
