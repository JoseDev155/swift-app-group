import UIKit

final class TravelEntryCell: UITableViewCell {
    static let reuseIdentifier = "TravelEntryCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let detailsContainer = UIView()
    private let detailsLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func configure(with entry: TravelEntry, expanded: Bool, formatter: DateFormatter) {
        titleLabel.text = entry.country
        subtitleLabel.text = entry.city
        dateLabel.text = formatter.string(from: entry.date)
        detailsLabel.text = entry.notes.isEmpty ? "Sin notas" : entry.notes
        setExpanded(expanded, animated: false)
    }

    func setExpanded(_ expanded: Bool, animated: Bool) {
        if animated {
            if expanded {
                detailsContainer.isHidden = false
                detailsContainer.alpha = 0
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.fromValue = 0.98
                animation.toValue = 1
                animation.duration = 0.2
                animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
                detailsContainer.layer.add(animation, forKey: "expand")
                UIView.animate(withDuration: 0.2) {
                    self.detailsContainer.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.detailsContainer.alpha = 0
                }, completion: { _ in
                    self.detailsContainer.isHidden = true
                })
            }
        } else {
            detailsContainer.isHidden = !expanded
            detailsContainer.alpha = expanded ? 1 : 0
        }
    }

    private func configure() {
        selectionStyle = .none

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .secondaryLabel

        detailsLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        detailsLabel.textColor = .label
        detailsLabel.numberOfLines = 0

        detailsContainer.layer.cornerRadius = 10
        detailsContainer.backgroundColor = UIColor.systemGray6

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, dateLabel, detailsContainer])
        stack.axis = .vertical
        stack.spacing = 6

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsContainer.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        detailsContainer.addSubview(detailsLabel)
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: detailsContainer.topAnchor, constant: 8),
            detailsLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 8),
            detailsLabel.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -8),
            detailsLabel.bottomAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: -8),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        detailsContainer.isHidden = true
        detailsContainer.alpha = 0
    }
}
