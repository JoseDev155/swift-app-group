import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let habitsViewController = UINavigationController(rootViewController: HabitsListViewController())
        habitsViewController.tabBarItem = UITabBarItem(
            title: "Habitos",
            image: UIImage(systemName: "checklist"),
            tag: 0
        )

        let statsViewController = UINavigationController(rootViewController: StatsViewController())
        statsViewController.tabBarItem = UITabBarItem(
            title: "Resumen",
            image: UIImage(systemName: "chart.bar"),
            tag: 1
        )

        viewControllers = [habitsViewController, statsViewController]
    }
}
