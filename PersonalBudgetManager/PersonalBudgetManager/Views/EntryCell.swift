import UIKit

final class EntryCell: UITableViewCell {
    static let reuseIdentifier = "EntryCell"

    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let amountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func configure(with entry: BudgetEntry, formatter: NumberFormatter) {
        titleLabel.text = entry.title
        categoryLabel.text = entry.category

        let amountText = formatter.string(from: NSNumber(value: entry.amount)) ?? "0"
        amountLabel.text = "\(entry.type.sign) \(amountText)"
        amountLabel.textColor = entry.type == .expense ? .systemRed : .systemGreen
    }

    private func configure() {
        selectionStyle = .none

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label

        categoryLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        categoryLabel.textColor = .secondaryLabel

        amountLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        amountLabel.textAlignment = .right

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(amountLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -12),

            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -12),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
