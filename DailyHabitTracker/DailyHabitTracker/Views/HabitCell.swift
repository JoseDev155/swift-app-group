import UIKit

final class HabitCell: UITableViewCell {
    static let reuseIdentifier = "HabitCell"

    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let checkmarkView = CheckmarkView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        checkmarkView.setChecked(false, animated: false)
    }

    func configure(with habit: Habit, completed: Bool, animated: Bool) {
        titleLabel.text = habit.title
        detailLabel.text = habit.detail
        checkmarkView.setChecked(completed, animated: animated)
    }

    private func configure() {
        selectionStyle = .none

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        detailLabel.textColor = .secondaryLabel

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(checkmarkView)

        NSLayoutConstraint.activate([
            checkmarkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkView.widthAnchor.constraint(equalToConstant: 22),
            checkmarkView.heightAnchor.constraint(equalToConstant: 22),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkmarkView.leadingAnchor, constant: -12),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkmarkView.leadingAnchor, constant: -12),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
