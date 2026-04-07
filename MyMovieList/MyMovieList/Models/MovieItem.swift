//
//  MovieItem.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

enum MovieGenre: String, Codable, CaseIterable {
    case action
    case drama
    case comedy
    case horror
    case sciFi
    case animation
    case romance

    var title: String {
        switch self {
        case .action:
            return "Accion"
        case .drama:
            return "Drama"
        case .comedy:
            return "Comedia"
        case .horror:
            return "Terror"
        case .sciFi:
            return "Ciencia ficcion"
        case .animation:
            return "Animacion"
        case .romance:
            return "Romance"
        }
    }

    var defaultPosterSymbol: String {
        switch self {
        case .action:
            return "bolt.fill"
        case .drama:
            return "theatermasks.fill"
        case .comedy:
            return "face.smiling.fill"
        case .horror:
            return "exclamationmark.triangle.fill"
        case .sciFi:
            return "sparkles"
        case .animation:
            return "film.stack.fill"
        case .romance:
            return "heart.fill"
        }
    }

    static func fromInput(_ text: String) -> MovieGenre? {
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "accion", "action":
            return .action
        case "drama":
            return .drama
        case "comedia", "comedy":
            return .comedy
        case "terror", "horror":
            return .horror
        case "ciencia ficcion", "ciencia", "scifi", "sci-fi", "sci fi":
            return .sciFi
        case "animacion", "animation":
            return .animation
        case "romance":
            return .romance
        default:
            return nil
        }
    }
}

struct MovieItem: Hashable, Codable {
    let id: String
    let title: String
    let genre: MovieGenre
    let year: Int
    let posterSymbolName: String
    let note: String
    let isWatched: Bool
    let createdAt: Date
}

extension Date {
    private static let movieShortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    func movieShortDate() -> String {
        Date.movieShortFormatter.string(from: self)
    }
}
