
import UIKit

protocol CurrencyListViewControllerDelegate: AnyObject {
    func savedSymbolPair(_ pair: CurrencyPairDTO)
}

final class CurrencyListViewController: UIViewController {

    var presenter: CurrencyListViewToPresenterProtocol?
    private var currencies: [CurrencyPairDTO] = []
    private lazy var tableView = makeMainTableView()
    private lazy var activityIndicatorView = makeActivityIndicatorView()
    private lazy var emptyStateView = makeEmptyStateView()
    
    override func loadView() {
        super.loadView()
        addSubViews()
        addConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.CurrencyList.screenTitle
        view.backgroundColor = .white
        presenter?.onViewDidLoad()
    }
    
    private func toggleEmptyStateView(isOn: Bool, _ message: Message? = nil) {
        if let message = message {
            emptyStateView.configure(message)
            emptyStateView.animate()
        }
        emptyStateView.isHidden = !isOn
        tableView.isHidden = isOn
    }
}

extension CurrencyListViewController {
    private func addSubViews() {
        view.addSubview(activityIndicatorView)
        view.addSubview(emptyStateView)
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyStateView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func makeMainTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.register(CurrencyListCell.self, forCellReuseIdentifier: CurrencyListCell.cellId)
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }
    
    private func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.isHidden = true
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    private func makeEmptyStateView() -> CurrencyListEmptyView {
        let view = CurrencyListEmptyView()
        view.delegate = self
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension CurrencyListViewController: CurrencyListPresenterToViewProtocol {
    func showEmptyState(_ message: Message) {
        toggleEmptyStateView(isOn: true, message)
    }
    
    func showErrorAlert(_ message: Message) {
        let vc = UIAlertController(title: message.title, message: message.body, preferredStyle: .alert)
        present(vc, animated: true)
    }
    
    func showCurrencyPairs(_ pairs: [CurrencyPairDTO]) {
        currencies = pairs
        tableView.isHidden = false
        toggleEmptyStateView(isOn: false)
        tableView.reloadData()
    }
    
    func onDeleteListRow(at index: Int) {
        currencies.remove(at: index)
        addHaptic(style: .medium)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        tableView.endUpdates()
    }
    
    func appendCurrencyPair(_ pair: CurrencyPairDTO) {
        currencies.insert(pair, at: 0)
        toggleEmptyStateView(isOn: false)
        addHaptic(style: .rigid)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func showLoading() {
        tableView.isHidden = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func hideLoading() {
        activityIndicatorView.stopAnimating()
    }
    
    private func addHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

extension CurrencyListViewController: CurrencyListEmptyViewDelegate & CurrencyListSectionViewDelegate {
    func addButtonDidTap() {
        addHaptic(style: .soft)
        presenter?.showAddCurrencyScene(self)
    }
}

extension CurrencyListViewController: CurrencyListViewControllerDelegate {
    func savedSymbolPair(_ pair: CurrencyPairDTO) {
        presenter?.addedCurrencyPair(pair)
    }
}

extension CurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListCell.cellId) as! CurrencyListCell
        cell.configure(pair: currencies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CurrencyListSectionView()
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            presenter?.deleteCurrencyPair(at: indexPath.row)
        default:
            break
        }
    }
}
