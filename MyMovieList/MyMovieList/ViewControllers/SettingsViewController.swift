//
//  SettingsViewController.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let viewModel: MovieSettingsViewModel
    private let sortControl = UISegmentedControl(items: MovieSortOption.allCases.map { $0.title })
    private let genreLabel = UILabel()
    private let yearLabel = UILabel()

    init(viewModel: MovieSettingsViewModel = MovieSettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ajustes"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureLayout()
        configureLabels()
        updateContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: MovieNotifications.moviesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChanged), name: MovieNotifications.settingsDidChange, object: nil)
        handleDataChanged()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: MovieNotifications.moviesDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: MovieNotifications.settingsDidChange, object: nil)
    }

    private func configureLayout() {
        sortControl.translatesAutoresizingMaskIntoConstraints = false
        sortControl.addTarget(self, action: #selector(sortChanged), for: .valueChanged)

        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [sortControl, genreLabel, yearLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureLabels() {
        genreLabel.font = .preferredFont(forTextStyle: .footnote)
        genreLabel.textColor = .secondaryLabel
        genreLabel.numberOfLines = 0

        yearLabel.font = .preferredFont(forTextStyle: .footnote)
        yearLabel.textColor = .secondaryLabel
        yearLabel.numberOfLines = 0
    }

    private func updateContent() {
        sortControl.selectedSegmentIndex = MovieSortOption.allCases.firstIndex(of: viewModel.sortOption) ?? 0
        genreLabel.text = viewModel.genreSummaryText()
        yearLabel.text = viewModel.yearSummaryText()
    }

    @objc private func handleDataChanged() {
        updateContent()
    }

    @objc private func sortChanged() {
        let option = MovieSortOption.allCases[sortControl.selectedSegmentIndex]
        viewModel.updateSortOption(option)
    }
}
