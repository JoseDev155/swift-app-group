import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let tasksController = UINavigationController(rootViewController: TaskListViewController())
        tasksController.tabBarItem = UITabBarItem(title: "Tareas", image: UIImage(systemName: "checklist"), tag: 0)

        let summaryController = UINavigationController(rootViewController: TaskSummaryViewController())
        summaryController.tabBarItem = UITabBarItem(title: "Resumen", image: UIImage(systemName: "chart.bar"), tag: 1)

        viewControllers = [tasksController, summaryController]
    }
}
