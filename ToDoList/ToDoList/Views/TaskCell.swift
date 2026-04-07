import UIKit

final class TaskCell: UITableViewCell {
    static let reuseIdentifier = "TaskCell"

    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let dueLabel = UILabel()
    private let badgeView = PriorityBadgeView()
    private let statusIndicator = UIView()

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
        statusIndicator.layer.removeAllAnimations()
    }

    func configure(with task: TaskItem, formatter: DateFormatter) {
        titleLabel.text = task.title
        detailLabel.text = task.detail
        dueLabel.text = "Vence: \(formatter.string(from: task.dueDate))"
        badgeView.setPriority(task.priority)

        if task.isCompleted {
            titleLabel.textColor = .secondaryLabel
            detailLabel.textColor = .secondaryLabel
            statusIndicator.backgroundColor = .systemGray3
            statusIndicator.layer.removeAllAnimations()
        } else if task.isExpired {
            titleLabel.textColor = .systemRed
            detailLabel.textColor = .systemRed
            statusIndicator.backgroundColor = .systemRed
            animateExpiredIndicator()
        } else {
            titleLabel.textColor = .label
            detailLabel.textColor = .secondaryLabel
            statusIndicator.backgroundColor = .systemBlue
            statusIndicator.layer.removeAllAnimations()
        }
    }

    private func configure() {
        selectionStyle = .none

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        dueLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dueLabel.textColor = .secondaryLabel

        statusIndicator.layer.cornerRadius = 4
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        dueLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(statusIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(dueLabel)
        contentView.addSubview(badgeView)

        NSLayoutConstraint.activate([
            statusIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusIndicator.widthAnchor.constraint(equalToConstant: 8),
            statusIndicator.heightAnchor.constraint(equalToConstant: 8),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: badgeView.leadingAnchor, constant: -12),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dueLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 4),
            dueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dueLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            badgeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            badgeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    private func animateExpiredIndicator() {
        let pulse = CABasicAnimation(keyPath: "opacity")
        pulse.fromValue = 0.4
        pulse.toValue = 1
        pulse.duration = 0.6
        pulse.autoreverses = true
        pulse.repeatCount = 2
        statusIndicator.layer.add(pulse, forKey: "pulse")
    }
}
