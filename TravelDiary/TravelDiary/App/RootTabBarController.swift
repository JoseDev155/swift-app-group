import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let listController = UINavigationController(rootViewController: TravelListViewController())
        listController.tabBarItem = UITabBarItem(title: "Diario", image: UIImage(systemName: "airplane"), tag: 0)

        let summaryController = UINavigationController(rootViewController: TravelSummaryViewController())
        summaryController.tabBarItem = UITabBarItem(title: "Resumen", image: UIImage(systemName: "chart.bar"), tag: 1)

        let settingsController = UINavigationController(rootViewController: TravelSettingsViewController())
        settingsController.tabBarItem = UITabBarItem(title: "Ajustes", image: UIImage(systemName: "gear"), tag: 2)

        viewControllers = [listController, summaryController, settingsController]
    }
}
