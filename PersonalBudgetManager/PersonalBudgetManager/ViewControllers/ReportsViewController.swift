import UIKit

final class ReportsViewController: UIViewController {
    private let viewModel: ReportsViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()

    init(viewModel: ReportsViewModel = ReportsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reportes"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEntriesChanged), name: BudgetNotifications.entriesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEntriesChanged), name: BudgetNotifications.limitDidChange, object: nil)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: BudgetNotifications.entriesDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: BudgetNotifications.limitDidChange, object: nil)
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

    private func format(_ value: Double) -> String {
        formatter.string(from: NSNumber(value: value)) ?? "0"
    }
}

extension ReportsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return viewModel.categoryTotals().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let summary = viewModel.summary()

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Ingresos"
                cell.detailTextLabel?.text = format(summary.income)
                cell.detailTextLabel?.textColor = .systemGreen
            case 1:
                cell.textLabel?.text = "Gastos"
                cell.detailTextLabel?.text = format(summary.expense)
                cell.detailTextLabel?.textColor = .systemRed
            default:
                cell.textLabel?.text = "Balance"
                cell.detailTextLabel?.text = format(summary.balance)
                cell.detailTextLabel?.textColor = summary.balance >= 0 ? .systemGreen : .systemRed
            }
            return cell
        }

        let totals = viewModel.categoryTotals()
        let item = totals[indexPath.row]
        cell.textLabel?.text = item.category
        cell.detailTextLabel?.text = format(item.total)
        cell.detailTextLabel?.textColor = .label
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Resumen"
        }
        return "Gastos por categoria"
    }
}

extension ReportsViewController: UITableViewDelegate {}
