//
//  Notifications.swift
//  InventoryControl
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum InventoryNotifications {
    static let inventoryDidChange = Notification.Name("InventoryControl.inventoryDidChange")
    static let profileDidChange = Notification.Name("InventoryControl.profileDidChange")
    static let scanHistoryDidChange = Notification.Name("InventoryControl.scanHistoryDidChange")
}
