import UIKit

final class StatsViewController: UIViewController {
    private let viewModel: StatsViewModel

    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)

    init(viewModel: StatsViewModel = StatsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resumen"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureLayout()
        updateUI(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCompletionDidChange),
            name: HabitNotifications.completionDidChange,
            object: nil
        )
        updateUI(animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: HabitNotifications.completionDidChange, object: nil)
    }

    @objc private func handleCompletionDidChange() {
        updateUI(animated: true)
    }

    private func configureLayout() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0

        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0

        progressView.trackTintColor = UIColor.systemGray5
        progressView.progressTintColor = UIColor.systemGreen

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            progressView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    private func updateUI(animated: Bool) {
        let summary = viewModel.summary()
        titleLabel.text = summary.title
        detailLabel.text = summary.detail
        progressView.setProgress(summary.progress, animated: animated)
    }
}
