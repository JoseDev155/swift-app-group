//
//  RootTabBarController.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let listController = UINavigationController(rootViewController: MoviesListViewController())
        listController.tabBarItem = UITabBarItem(title: "Lista", image: UIImage(systemName: "film"), tag: 0)

        let settingsController = UINavigationController(rootViewController: SettingsViewController())
        settingsController.tabBarItem = UITabBarItem(title: "Ajustes", image: UIImage(systemName: "gearshape"), tag: 1)

        viewControllers = [listController, settingsController]
    }
}
