
import UIKit

final class CurrencyListRouter: CurrencyListPresenterToRouterProtocol {
    
    weak var viewController: CurrencyListViewController?
    
    init(viewController: CurrencyListViewController) {
        self.viewController = viewController
    }
    
    static func createModule() -> UIViewController {
        let viewController = CurrencyListViewController()
        let presenter: CurrencyListViewToPresenterProtocol & CurrencyListInteractorToPresenterProtocol = CurrencyListPresenter(view: viewController)
        let coreDataStack = CoreDataStack()
        let storeService = CurrencyStoreService(managedObjectContext: coreDataStack.mainContext,
                                                coreDataStack: coreDataStack)
        let interactor = CurrencyListInteractor(presenter: presenter,
                                                remoteService: APIClient(),
                                                storeService: storeService,
                                                reachabilityService: ReachabilityService.shared)
        let router = CurrencyListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        return viewController
    }
    
    func showAddCurrencyScene(from module: CurrencyListViewController,
                              symbols: [CurrencySymbolDTO]) {
        let addCurrencyVC = AddCurrencyRouter.createModule(previousModule: module,
                                                           symbols: symbols)
        if let sheet = addCurrencyVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 24
            sheet.prefersGrabberVisible = true
        }
        viewController?.present(addCurrencyVC, animated: true)
    }
}
