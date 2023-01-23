
import XCTest
@testable import CurrencyRate

class CurrencyListInteractorTests: XCTestCase {
    
    var interactor: CurrencyListInteractor!
    var presenter: CurrencyListPresenterProtocol!
    
    override func setUpWithError() throws {
        
    }

    func testFetchCurrecyRatesSuccess() throws {
        let currencyRates = CurrencyRateResponse(base: "USD",
                                                 date: "",
                                                 rates: ["RUB": 72.031232],
                                                 timestamp: 0)
        let remoteService = CurrencyAPIMock(currencyRates: currencyRates)
        let reachabilityService = ReachabilityServiceMock(isConnected: true)
        let coreDataStack = TestCoreDataStack()
        let storeService = CurrencyStoreService(managedObjectContext: coreDataStack.mainContext,
                                                coreDataStack: coreDataStack)
        presenter = CurrencyListPresenterMock()
        interactor = CurrencyListInteractor(presenter: presenter,
                                            remoteService: remoteService,
                                            storeService: storeService,
                                            reachabilityService: reachabilityService)
        storeService.add(base: "USD", baseName: "United States Dollar",
                         secondary: "RUB", secondaryName: "Russian Ruble")
        
        
        interactor.getCurrencySymbolsAndRates()
        
        XCTAssertEqual(interactor.currencyPairs.count, 1)
    }

}

extension

final class CurrencyListPresenterMock: CurrencyListPresenterProtocol {
    var expectation: XCTestExpectation?
    
    func onViewDidLoad() {
        
    }
    
    func onAddedCurrencyPair(_ pair: CurrencyPairDTO) {
        
    }
    
    func onDeletedCurrencyPair(at index: Int) {
        
    }
    
    func deleteListRow(at index: Int) {
        
    }
    
    func screenStateChanged(_ state: CurrencyListState) {
        
    }
    
    func showAddCurrencyScene(_ module: CurrencyListViewController) {
        
    }
    
}

final class ReachabilityServiceMock: ReachabilityServiceProtocol {
    var isConnected = true
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}

final class CurrencyAPIMock: CurrencyAPI {
    
    private var currencyRates: CurrencyRateResponse?
    private var networkError: NetworkError?
    
    init(currencyRates: CurrencyRateResponse? = nil,
         networkError: NetworkError? = nil) {
        self.currencyRates = currencyRates
        self.networkError = networkError
    }
    
    func fetchCurrencyRate(base: String, symbols: String, completion: @escaping ParsedCompletion<CurrencyRateResponse>) {
        completion(currencyRates, networkError)
    }
    
    func fetchCurrencySymbols(completion: @escaping ParsedCompletion<CurrencySymbolResponse>) {
        let symbols: [String: String] = [
            "RUB": "Russian Ruble",
            "EUR": "Euro",
            "USD": "United States Dollar",
            "NZD": "New Zealand Dollar"
        ]
        completion(CurrencySymbolResponse(symbols: symbols), networkError)
    }
}
