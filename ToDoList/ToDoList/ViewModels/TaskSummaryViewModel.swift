import Foundation

struct PrioritySummaryItem {
    let title: String
    let count: Int
}

struct TaskSummary {
    let total: Int
    let completed: Int
    let expired: Int
}

final class TaskSummaryViewModel {
    private let store: TaskStoreProtocol

    init(store: TaskStoreProtocol = TaskStore.shared) {
        self.store = store
    }

    func summary() -> TaskSummary {
        let total = store.tasks.count
        let completed = store.tasks.filter { $0.isCompleted }.count
        let expired = store.tasks.filter { $0.isExpired }.count
        return TaskSummary(total: total, completed: completed, expired: expired)
    }

    func prioritySummary() -> [PrioritySummaryItem] {
        var counts: [TaskPriority: Int] = [:]
        for task in store.tasks {
            counts[task.priority, default: 0] += 1
        }

        return TaskPriority.allCases
            .sorted { $0.sortOrder < $1.sortOrder }
            .map { PrioritySummaryItem(title: $0.title, count: counts[$0, default: 0]) }
    }
}
