//
//  Notifications.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum MovieNotifications {
    static let moviesDidChange = Notification.Name("MyMovieList.moviesDidChange")
    static let settingsDidChange = Notification.Name("MyMovieList.settingsDidChange")
}
