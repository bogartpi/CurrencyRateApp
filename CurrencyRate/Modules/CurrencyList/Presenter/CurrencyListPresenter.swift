
import Foundation

protocol CurrencyListPresenterProtocol: AnyObject {
    func configureView()
}

final class CurrencyListPresenter {
    weak var view: CurrencyListViewControllerProtocol!
    var interactor: CurrencyListInteractorProtocol!
    var router: CurrencyListRouter!
    
    required init(view: CurrencyListViewControllerProtocol) {
        self.view = view
    }
    
    func configureView() {
        
    }
}
