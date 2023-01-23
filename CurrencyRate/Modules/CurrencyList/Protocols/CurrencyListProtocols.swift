
import Foundation

protocol CurrencyListPresenterToRouterProtocol: AnyObject {
    func showAddCurrencyScene(from module: CurrencyListViewController, symbols: [CurrencySymbolDTO])
}

protocol CurrencyListPresenterToViewProtocol: AnyObject {
    func showCurrencyPairs(_ pairs: [CurrencyPairDTO])
    func onDeleteListRow(at index: Int)
    func appendCurrencyPair(_ pair: CurrencyPairDTO)
    func showLoading()
    func hideLoading()
    func showEmptyState(_ message: Message)
    func showErrorAlert(_ message: Message)
}

protocol CurrencyListPresenterToInteractorProtocol: AnyObject {
    var currencySymbols: [CurrencySymbolDTO] { get }
    func fetchLocalSymbols()
    func fetchLocalCurrencyPairs()
    func getCurrencySymbolsAndRates()
    func getCurrencyRateForAddedPair(_ pair: CurrencyPairDTO)
    func deleteCurrencyPair(at index: Int)
}

protocol CurrencyListViewToPresenterProtocol: AnyObject {
    var view: CurrencyListPresenterToViewProtocol? { get set }
    var interactor: CurrencyListPresenterToInteractorProtocol? { get set }
    var router: CurrencyListPresenterToRouterProtocol? { get set }
    func onViewDidLoad()
    func deleteCurrencyPair(at index: Int)
    func addedCurrencyPair(_ pair: CurrencyPairDTO)
    func showAddCurrencyScene(_ module: CurrencyListViewController)
}

protocol CurrencyListInteractorToPresenterProtocol: AnyObject {
    func deleteListRow(at index: Int)
    func fetchedCurrencyPairs(_ pairs: [CurrencyPairDTO])
    func fetchedAddedCurrencyPair(_ pair: CurrencyPairDTO)
    func networkErrorThrown(_ error: NetworkError)
    func showEmptyState(_ message: Message)
    func toggleLoading(_ isLoading: Bool)
}
