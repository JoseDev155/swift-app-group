//
//  RootTabBarController.swift
//  StudyCards
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let listController = UINavigationController(rootViewController: CardsListViewController())
        listController.tabBarItem = UITabBarItem(title: "Tarjetas", image: UIImage(systemName: "rectangle.on.rectangle"), tag: 0)

        let studyController = UINavigationController(rootViewController: StudyViewController())
        studyController.tabBarItem = UITabBarItem(title: "Estudio", image: UIImage(systemName: "rectangle.2.swap"), tag: 1)

        viewControllers = [listController, studyController]
    }
}
