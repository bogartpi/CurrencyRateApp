
import Foundation

protocol CurrencyListInteractorProtocol: AnyObject {
    
}

final class CurrencyListInteractor {
    weak var presenter: CurrencyListPresenter!
    
    required init(presenter: CurrencyListPresenter) {
        self.presenter = presenter
    }
    
    var screenTitle = "Курсы валютных пар"
}
