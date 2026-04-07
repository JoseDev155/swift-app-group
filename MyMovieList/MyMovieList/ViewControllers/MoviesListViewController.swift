//
//  MoviesListViewController.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class MoviesListViewController: UIViewController {
    private let viewModel: MovieListViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: MovieListViewModel = MovieListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Peliculas"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMovie))
        navigationItem.leftBarButtonItem = editButtonItem
        configureTableView()
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

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 92

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleDataChanged() {
        tableView.reloadData()
    }

    @objc private func addMovie() {
        presentMovieForm(context: .new)
    }

    private func presentMovieForm(context: EntryContext<MovieItem>) {
        let title: String
        let movie: MovieItem?

        switch context {
        case .new:
            title = "Nueva pelicula"
            movie = nil
        case .edit(let current):
            title = "Editar pelicula"
            movie = current
        }

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Titulo"
            textField.text = movie?.title
        }
        alert.addTextField { textField in
            textField.placeholder = "Genero (Accion, Drama, Comedia, Terror)"
            textField.text = movie?.genre.title
        }
        alert.addTextField { textField in
            textField.placeholder = "Anio"
            textField.keyboardType = .numberPad
            if let movie = movie {
                textField.text = "\(movie.year)"
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Poster (SF Symbol opcional)"
            textField.text = movie?.posterSymbolName
        }
        alert.addTextField { textField in
            textField.placeholder = "Nota (opcional)"
            textField.text = movie?.note
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let titleText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let genreText = alert.textFields?.dropFirst().first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let yearText = alert.textFields?.dropFirst(2).first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let posterText = alert.textFields?.dropFirst(3).first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let noteText = alert.textFields?.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard !titleText.isEmpty else {
                self.presentValidationAlert(message: "Ingresa un titulo valido.")
                return
            }

            guard let genre = MovieGenre.fromInput(genreText) else {
                self.presentValidationAlert(message: "Selecciona un genero valido.")
                return
            }

            guard let year = Int(yearText), year >= 1900, year <= 2100 else {
                self.presentValidationAlert(message: "Ingresa un anio valido.")
                return
            }

            let posterName = posterText.isEmpty ? genre.defaultPosterSymbol : posterText

            if let movie = movie {
                self.viewModel.updateMovie(id: movie.id, title: titleText, genre: genre, year: year, posterSymbolName: posterName, note: noteText)
            } else {
                self.viewModel.addMovie(title: titleText, genre: genre, year: year, posterSymbolName: posterName, note: noteText)
            }
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    private func confirmDelete(at indexPath: IndexPath) {
        let movie = viewModel.movie(at: indexPath.row)
        let alert = UIAlertController(
            title: "Eliminar pelicula",
            message: "Deseas eliminar \"\(movie.title)\"?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.animateDeletion(at: indexPath, movie: movie)
        })
        present(alert, animated: true)
    }

    private func animateDeletion(at indexPath: IndexPath, movie: MovieItem) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            viewModel.deleteMovie(id: movie.id)
            return
        }

        UIView.animate(withDuration: 0.25, animations: {
            cell.contentView.alpha = 0
        }, completion: { [weak self] _ in
            cell.contentView.alpha = 1
            self?.viewModel.deleteMovie(id: movie.id)
        })
    }

    private func presentValidationAlert(message: String) {
        let alert = UIAlertController(title: "Datos invalidos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.movie(at: indexPath.row))
        return cell
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        confirmDelete(at: indexPath)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = viewModel.movie(at: indexPath.row)

        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completion in
            self?.confirmDelete(at: indexPath)
            completion(true)
        }

        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completion in
            guard let self = self else { return }
            let movie = self.viewModel.movie(at: indexPath.row)
            self.presentMovieForm(context: .edit(movie))
            completion(true)
        }
        editAction.backgroundColor = .systemBlue

        let toggleTitle = movie.isWatched ? "Pendiente" : "Visto"
        let toggleAction = UIContextualAction(style: .normal, title: toggleTitle) { [weak self] _, _, completion in
            guard let self = self else { return }
            self.viewModel.toggleWatched(id: movie.id)
            if let cell = tableView.cellForRow(at: indexPath) as? MovieCell {
                cell.animatePosterPulse()
            }
            completion(true)
        }
        toggleAction.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, toggleAction])
    }
}
