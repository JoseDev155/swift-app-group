//
//  RootTabBarController.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let hydrationController = UINavigationController(rootViewController: HydrationListViewController())
        hydrationController.tabBarItem = UITabBarItem(title: "Agua", image: UIImage(systemName: "drop.fill"), tag: 0)

        let sleepController = UINavigationController(rootViewController: SleepListViewController())
        sleepController.tabBarItem = UITabBarItem(title: "Sueno", image: UIImage(systemName: "bed.double.fill"), tag: 1)

        let settingsController = UINavigationController(rootViewController: SettingsViewController())
        settingsController.tabBarItem = UITabBarItem(title: "Ajustes", image: UIImage(systemName: "gearshape.fill"), tag: 2)

        viewControllers = [hydrationController, sleepController, settingsController]
    }
}
