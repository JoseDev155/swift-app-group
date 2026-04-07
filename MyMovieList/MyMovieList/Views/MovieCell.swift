//
//  MovieCell.swift
//  MyMovieList
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class MovieCell: UITableViewCell {
    static let reuseIdentifier = "MovieCell"

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let badgeLabel = UILabel()
    private let badgeView = UIView()
    private let noteLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.alpha = 1
        posterImageView.alpha = 1
    }

    func configure(with movie: MovieItem) {
        let symbol = movie.posterSymbolName.isEmpty ? movie.genre.defaultPosterSymbol : movie.posterSymbolName
        posterImageView.image = UIImage(systemName: symbol)
        posterImageView.tintColor = movie.isWatched ? .systemGreen : .systemIndigo

        titleLabel.text = movie.title
        subtitleLabel.text = "\(movie.genre.title) · \(movie.year) · \(movie.createdAt.movieShortDate())"
        noteLabel.text = movie.note.isEmpty ? "Sin nota" : movie.note

        badgeLabel.text = movie.isWatched ? "Visto" : "Pendiente"
        badgeView.backgroundColor = movie.isWatched ? UIColor.systemGreen.withAlphaComponent(0.15) : UIColor.systemOrange.withAlphaComponent(0.18)
        badgeLabel.textColor = movie.isWatched ? .systemGreen : .systemOrange
    }

    func animatePosterPulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.08
        animation.duration = 0.2
        animation.autoreverses = true
        posterImageView.layer.add(animation, forKey: "pulse")
    }

    private func configureView() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.layer.cornerRadius = 12
        posterImageView.backgroundColor = UIColor.systemGray6
        posterImageView.tintColor = .systemIndigo

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel

        noteLabel.font = .preferredFont(forTextStyle: .footnote)
        noteLabel.textColor = .tertiaryLabel
        noteLabel.numberOfLines = 2

        badgeLabel.font = .preferredFont(forTextStyle: .caption1)
        badgeLabel.textAlignment = .center

        badgeView.layer.cornerRadius = 10
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.addSubview(badgeLabel)
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, noteLabel, badgeView])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        contentView.addSubview(textStack)

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 54),
            posterImageView.heightAnchor.constraint(equalToConstant: 72),

            textStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 8),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -8),
            badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 4),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -4)
        ])
    }
}
