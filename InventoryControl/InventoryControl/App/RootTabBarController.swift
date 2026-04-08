//
//  RootTabBarController.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let inventoryController = UINavigationController(rootViewController: InventoryListViewController())
        inventoryController.tabBarItem = UITabBarItem(title: "Inventario", image: UIImage(systemName: "cube.box.fill"), tag: 0)

        let scannerController = UINavigationController(rootViewController: ScannerViewController())
        scannerController.tabBarItem = UITabBarItem(title: "Escáner", image: UIImage(systemName: "barcode.viewfinder"), tag: 1)

        let historyController = UINavigationController(rootViewController: ScanHistoryViewController())
        historyController.tabBarItem = UITabBarItem(title: "Historial", image: UIImage(systemName: "clock.arrow.circlepath"), tag: 2)

        let profileController = UINavigationController(rootViewController: ProfileViewController())
        profileController.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person.crop.circle"), tag: 3)

        viewControllers = [inventoryController, scannerController, historyController, profileController]
    }
}
