//
//  MovieStore.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

protocol MovieStoreProtocol {
    var movies: [MovieItem] { get }
    var sortOption: MovieSortOption { get }

    func addMovie(title: String, genre: MovieGenre, year: Int, posterSymbolName: String, note: String) -> MovieItem
    func updateMovie(id: String, title: String, genre: MovieGenre, year: Int, posterSymbolName: String, note: String)
    func deleteMovie(id: String)
    func toggleWatched(id: String)

    func updateSortOption(_ option: MovieSortOption)
    func moviesByGenreCount() -> [MovieGenre: Int]
    func moviesByYearCount() -> [Int: Int]
}

final class MovieStore: MovieStoreProtocol {
    static let shared = MovieStore()

    private let defaults: UserDefaults
    private static let moviesKey = "MyMovieList.movies"
    private static let sortKey = "MyMovieList.sortOption"

    private(set) var movies: [MovieItem]
    private(set) var sortOption: MovieSortOption

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.movies = MovieStore.loadMovies(defaults: defaults)
        self.sortOption = MovieStore.loadSortOption(defaults: defaults)
    }

    func addMovie(title: String, genre: MovieGenre, year: Int, posterSymbolName: String, note: String) -> MovieItem {
        let movie = MovieItem(
            id: UUID().uuidString,
            title: title,
            genre: genre,
            year: year,
            posterSymbolName: posterSymbolName,
            note: note,
            isWatched: false,
            createdAt: Date()
        )
        movies.insert(movie, at: 0)
        saveMovies()
        notifyMoviesChanged()
        return movie
    }

    func updateMovie(id: String, title: String, genre: MovieGenre, year: Int, posterSymbolName: String, note: String) {
        guard let index = movies.firstIndex(where: { $0.id == id }) else { return }
        let current = movies[index]
        movies[index] = MovieItem(
            id: current.id,
            title: title,
            genre: genre,
            year: year,
            posterSymbolName: posterSymbolName,
            note: note,
            isWatched: current.isWatched,
            createdAt: current.createdAt
        )
        saveMovies()
        notifyMoviesChanged()
    }

    func deleteMovie(id: String) {
        guard let index = movies.firstIndex(where: { $0.id == id }) else { return }
        movies.remove(at: index)
        saveMovies()
        notifyMoviesChanged()
    }

    func toggleWatched(id: String) {
        guard let index = movies.firstIndex(where: { $0.id == id }) else { return }
        let current = movies[index]
        movies[index] = MovieItem(
            id: current.id,
            title: current.title,
            genre: current.genre,
            year: current.year,
            posterSymbolName: current.posterSymbolName,
            note: current.note,
            isWatched: !current.isWatched,
            createdAt: current.createdAt
        )
        saveMovies()
        notifyMoviesChanged()
    }

    func updateSortOption(_ option: MovieSortOption) {
        sortOption = option
        defaults.set(option.rawValue, forKey: MovieStore.sortKey)
        NotificationCenter.default.post(name: MovieNotifications.settingsDidChange, object: nil)
    }

    func moviesByGenreCount() -> [MovieGenre: Int] {
        var totals: [MovieGenre: Int] = [:]
        for movie in movies {
            totals[movie.genre, default: 0] += 1
        }
        return totals
    }

    func moviesByYearCount() -> [Int: Int] {
        var totals: [Int: Int] = [:]
        for movie in movies {
            totals[movie.year, default: 0] += 1
        }
        return totals
    }

    private func saveMovies() {
        guard let data = try? JSONEncoder().encode(movies) else { return }
        defaults.set(data, forKey: MovieStore.moviesKey)
    }

    private func notifyMoviesChanged() {
        NotificationCenter.default.post(name: MovieNotifications.moviesDidChange, object: nil)
    }

    private static func loadMovies(defaults: UserDefaults) -> [MovieItem] {
        if let data = defaults.data(forKey: MovieStore.moviesKey),
           let stored = try? JSONDecoder().decode([MovieItem].self, from: data) {
            return stored
        }
        return []
    }

    private static func loadSortOption(defaults: UserDefaults) -> MovieSortOption {
        if let value = defaults.string(forKey: MovieStore.sortKey),
           let option = MovieSortOption(rawValue: value) {
            return option
        }
        return .recent
    }
}
