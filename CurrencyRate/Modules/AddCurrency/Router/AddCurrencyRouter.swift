
import UIKit

final class AddCurrencyRouter: AddCurrencyRouterToPresenterProtocol {
    weak var viewController: AddCurrencyViewController!
    weak var delegate: CurrencyListViewControllerDelegate?
    
    init(viewController: AddCurrencyViewController) {
        self.viewController = viewController
    }
    
    static func createModule(previousModule: UIViewController,
                             symbols: [CurrencySymbolDTO]) -> UIViewController {
        let viewController = AddCurrencyViewController()
        typealias PresenterType = AddCurrencyViewToPresenterProtocol & AddCurrencyInteractorToPresenterProtocol
        let presenter: PresenterType = AddCurrencyPresenter(view: viewController)
        let coreDataStack = CoreDataStack()
        let storeService = CurrencyStoreService(managedObjectContext: coreDataStack.mainContext,
                                                coreDataStack: coreDataStack)
        let interactor: AddCurrencyPresenterToInteractorProtocol = AddCurrencyInteractor(presenter: presenter,
                                                                                         storeService: storeService)
        let router = AddCurrencyRouter(viewController: viewController)
        if let currencyListVC = previousModule as? CurrencyListViewController {
            router.delegate = currencyListVC
        }
        interactor.symbols = symbols
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        
        return viewController
    }
    
    func closeCurrentViewController() {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func closeCurrenViewControllerAfterAddingCurrency(_ pair: CurrencyPairDTO) {
        delegate?.savedSymbolPair(pair)
        viewController.dismiss(animated: true, completion: nil)
    }
}
