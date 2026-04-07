//
//  MovieListViewModel.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class MovieListViewModel {
    private let store: MovieStoreProtocol

    init(store: MovieStoreProtocol = MovieStore.shared) {
        self.store = store
    }

    var sortOption: MovieSortOption {
        store.sortOption
    }

    var movies: [MovieItem] {
        sortedMovies(store.movies)
    }

    func movie(at index: Int) -> MovieItem {
        movies[index]
    }

    func addMovie(title: String, genre: MovieGenre, year: Int, posterSymbolName: String, note: String) {
        _ = store.addMovie(title: title, genre: genre, year: year, posterSymbolName: posterSymbolName, note: note)
    }

    func updateMovie(id: String, title: String, genre: MovieGenre, year: Int, posterSymbolName: String, note: String) {
        store.updateMovie(id: id, title: title, genre: genre, year: year, posterSymbolName: posterSymbolName, note: note)
    }

    func deleteMovie(id: String) {
        store.deleteMovie(id: id)
    }

    func toggleWatched(id: String) {
        store.toggleWatched(id: id)
    }

    private func sortedMovies(_ movies: [MovieItem]) -> [MovieItem] {
        switch store.sortOption {
        case .title:
            return movies.sorted { $0.title.lowercased() < $1.title.lowercased() }
        case .recent:
            return movies.sorted { $0.createdAt > $1.createdAt }
        }
    }
}
