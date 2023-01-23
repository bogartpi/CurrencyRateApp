
import Foundation

protocol AddCurrencyRouterToPresenterProtocol: AnyObject {
    func closeCurrenViewControllerAfterAddingCurrency(_ pair: CurrencyPairDTO)
}

protocol AddCurrencyPresenterToViewProtocol: AnyObject {
    func setPicketView(with data: [CurrencySymbolDTO])
    func showSelectionCurrencyError(_ text: String)
}

protocol AddCurrencyInteractorToPresenterProtocol: AnyObject {
    func addedCurrencyPair(_ pair: CurrencyPairDTO)
    func failedToSaveCurrencyPair(_ errorText: String)
}

protocol AddCurrencyViewToPresenterProtocol: AnyObject {
    var view: AddCurrencyPresenterToViewProtocol? { get set }
    var interactor: AddCurrencyPresenterToInteractorProtocol? { get set }
    var router: AddCurrencyRouterToPresenterProtocol? { get set }
    func onViewDidLoad()
    func saveButtonTapped(selectedPair: [CurrencySymbolDTO])
}

protocol AddCurrencyPresenterToInteractorProtocol: AnyObject {
    var symbols: [CurrencySymbolDTO] { get set }
    var selectedCurrencySymbolPair: [CurrencySymbolDTO] { get set }
}
