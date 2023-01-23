
import Foundation

final class AddCurrencyPresenter {
    
    weak var view: AddCurrencyPresenterToViewProtocol?
    var interactor: AddCurrencyPresenterToInteractorProtocol?
    var router: AddCurrencyRouterToPresenterProtocol?
    
    required init(view: AddCurrencyPresenterToViewProtocol) {
        self.view = view
    }
}

extension AddCurrencyPresenter: AddCurrencyViewToPresenterProtocol {
    func onViewDidLoad() {
        view?.setPicketView(with: interactor?.symbols ?? [])
    }
    
    func saveButtonTapped(selectedPair: [CurrencySymbolDTO]) {
        interactor?.selectedCurrencySymbolPair = selectedPair
    }
}

extension AddCurrencyPresenter: AddCurrencyInteractorToPresenterProtocol {
    func addedCurrencyPair(_ pair: CurrencyPairDTO) {
        router?.closeCurrenViewControllerAfterAddingCurrency(pair)
    }
    
    func failedToSaveCurrencyPair(_ errorText: String) {
        view?.showSelectionCurrencyError(errorText)
    }
}
