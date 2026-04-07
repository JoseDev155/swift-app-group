import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let listController = UINavigationController(rootViewController: BudgetListViewController())
        listController.tabBarItem = UITabBarItem(title: "Movimientos", image: UIImage(systemName: "list.bullet.rectangle"), tag: 0)

        let reportsController = UINavigationController(rootViewController: ReportsViewController())
        reportsController.tabBarItem = UITabBarItem(title: "Reportes", image: UIImage(systemName: "chart.bar"), tag: 1)

        viewControllers = [listController, reportsController]
    }
}
