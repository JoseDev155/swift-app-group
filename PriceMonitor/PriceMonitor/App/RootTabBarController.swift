//
//  RootTabBarController.swift
//  PriceMonitor
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let pricesController = UINavigationController(rootViewController: PriceListViewController())
        pricesController.tabBarItem = UITabBarItem(title: "Precios", image: UIImage(systemName: "chart.line.uptrend.xyaxis"), tag: 0)

        let summaryController = UINavigationController(rootViewController: PriceSummaryViewController())
        summaryController.tabBarItem = UITabBarItem(title: "Resumen", image: UIImage(systemName: "list.bullet.rectangle"), tag: 1)

        viewControllers = [pricesController, summaryController]
    }
}
