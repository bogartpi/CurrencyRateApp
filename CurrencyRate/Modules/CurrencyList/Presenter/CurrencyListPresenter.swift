
import Foundation

final class CurrencyListPresenter {
    weak var view: CurrencyListPresenterToViewProtocol?
    var interactor: CurrencyListPresenterToInteractorProtocol?
    var router: CurrencyListPresenterToRouterProtocol?
    
    init(view: CurrencyListPresenterToViewProtocol) {
        self.view = view
    }
}

extension CurrencyListPresenter: CurrencyListViewToPresenterProtocol {
    func onViewDidLoad() {
        interactor?.getCurrencySymbolsAndRates()
    }
    
    func deleteCurrencyPair(at index: Int) {
        interactor?.deleteCurrencyPair(at: index)
    }
    
    func addedCurrencyPair(_ pair: CurrencyPairDTO) {
        interactor?.getCurrencyRateForAddedPair(pair)
    }
    
    func showAddCurrencyScene(_ module: CurrencyListViewController) {
        guard let symbols = interactor?.currencySymbols, !symbols.isEmpty else { return}
        router?.showAddCurrencyScene(from: module, symbols: symbols)
    }
}

extension CurrencyListPresenter: CurrencyListInteractorToPresenterProtocol {
    func deleteListRow(at index: Int) {
        view?.onDeleteListRow(at: index)
    }
    
    func fetchedCurrencyPairs(_ pairs: [CurrencyPairDTO]) {
        view?.showCurrencyPairs(pairs)
    }
    
    func fetchedAddedCurrencyPair(_ pair: CurrencyPairDTO) {
        view?.appendCurrencyPair(pair)
    }
    
    func networkErrorThrown(_ error: NetworkError) {
        var message = Message()
        switch error {
        case .networkUnavailable:
            message.body = "Network connection is lost"
        case .unauthenticated:
            message.body = "Your session has expired"
        default:
            message.body = "Unable to load data"
        }
        view?.showErrorAlert(message)
    }
    
    func showEmptyState(_ message: Message) {
        view?.showEmptyState(message)
    }
    
    func toggleLoading(_ isLoading: Bool) {
        if isLoading {
            view?.showLoading()
        } else {
            view?.hideLoading()
        }
    }
}
