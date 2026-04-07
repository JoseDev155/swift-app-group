//
//  MovieSettingsViewModel.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class MovieSettingsViewModel {
    private let store: MovieStoreProtocol

    init(store: MovieStoreProtocol = MovieStore.shared) {
        self.store = store
    }

    var sortOption: MovieSortOption {
        store.sortOption
    }

    func updateSortOption(_ option: MovieSortOption) {
        store.updateSortOption(option)
    }

    func genreSummaryText() -> String {
        let summary = store.moviesByGenreCount()
        guard !summary.isEmpty else {
            return "Generos: sin registros."
        }

        let lines = summary
            .sorted { $0.value > $1.value }
            .map { "\($0.key.title): \($0.value)" }

        return "Generos:\n" + lines.joined(separator: "\n")
    }

    func yearSummaryText() -> String {
        let summary = store.moviesByYearCount()
        guard !summary.isEmpty else {
            return "Por anio: sin registros."
        }

        let lines = summary
            .sorted { $0.key > $1.key }
            .map { "\($0.key): \($0.value)" }

        return "Por anio:\n" + lines.joined(separator: "\n")
    }
}
