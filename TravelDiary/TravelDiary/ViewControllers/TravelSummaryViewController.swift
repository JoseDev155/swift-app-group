import UIKit

final class TravelSummaryViewController: UIViewController {
    private let viewModel: TravelSummaryViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: TravelSummaryViewModel = TravelSummaryViewModel()) {
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
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEntriesChanged), name: TravelNotifications.entriesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEntriesChanged), name: TravelNotifications.preferencesDidChange, object: nil)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: TravelNotifications.entriesDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: TravelNotifications.preferencesDidChange, object: nil)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleEntriesChanged() {
        tableView.reloadData()
    }
}

extension TravelSummaryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return viewModel.yearSummary().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let summary = viewModel.summary()

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Viajes"
                cell.detailTextLabel?.text = String(summary.totalEntries)
            } else {
                cell.textLabel?.text = "Paises"
                cell.detailTextLabel?.text = String(summary.uniqueCountries)
            }
            return cell
        }

        let item = viewModel.yearSummary()[indexPath.row]
        cell.textLabel?.text = item.year
        cell.detailTextLabel?.text = String(item.count)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Resumen"
        }
        return "Por anio"
    }
}

extension TravelSummaryViewController: UITableViewDelegate {}
