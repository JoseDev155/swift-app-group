//
//  MovieSortOption.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum MovieSortOption: String, Codable, CaseIterable {
    case title
    case recent

    var title: String {
        switch self {
        case .title:
            return "Titulo"
        case .recent:
            return "Recientes"
        }
    }
}
