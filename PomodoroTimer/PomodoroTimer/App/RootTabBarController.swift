//
//  RootTabBarController.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let timerController = UINavigationController(rootViewController: TimerViewController())
        timerController.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "timer"), tag: 0)

        let sessionsController = UINavigationController(rootViewController: SessionsViewController())
        sessionsController.tabBarItem = UITabBarItem(title: "Sesiones", image: UIImage(systemName: "list.bullet.rectangle"), tag: 1)

        let settingsController = UINavigationController(rootViewController: SettingsViewController())
        settingsController.tabBarItem = UITabBarItem(title: "Ajustes", image: UIImage(systemName: "gearshape"), tag: 2)

        viewControllers = [timerController, sessionsController, settingsController]
    }
}
