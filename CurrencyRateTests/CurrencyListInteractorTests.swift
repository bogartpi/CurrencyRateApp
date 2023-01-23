
import XCTest
@testable import CurrencyRate

class CurrencyListInteractorTests: XCTestCase {
    
    var interactor: CurrencyListInteractor!
    var presenter: CurrencyListPresenterMock!

    override func tearDownWithError() throws {
        presenter = nil
        interactor = nil
    }
    
    func testFetchCurrecyRatesSuccessWhenHaveSavedCurrencies() throws {
        let storeService = makeStoreService()
        storeService.add(base: "USD", baseName: "", secondary: "RUB", secondaryName: "")
        
        let currencyRates = CurrencyRateResponse(base: "USD", date: "", rates: ["RUB": 72.031232], timestamp: 0)
        let remoteService = CurrencyAPIMock(currencyRates: currencyRates)
        
        presenter = CurrencyListPresenterMock()
        interactor = CurrencyListInteractor(presenter: presenter, remoteService: remoteService, storeService: storeService)
        
        let expectation = expectation(description: "Should fetch currency rates")
        presenter.expectation = expectation
        
        interactor.getCurrencySymbolsAndRates()
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testCurrencyListShouldHaveEmptyStateWhenNoCurrenciesSaved() {
        presenter = CurrencyListPresenterMock()
        interactor = CurrencyListInteractor(presenter: presenter,
                                            remoteService: CurrencyAPIMock(),
                                            storeService: makeStoreService())
        
        let expectation = expectation(description: "Should have empty state without saved currencies")
        presenter.expectation = expectation
        
        interactor.getCurrencySymbolsAndRates()
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testShouldLoadRatesSuccessWhenAddedCurrencyPair() {
        let pair = CurrencyPairDTO(base: "USD", baseDescription: "United States Dollar",
                                   secondary: "RUB", secondaryDescription: "Russian Ruble")
        let response = CurrencyRateResponse(base: pair.base, date: "", rates: [pair.secondary: 67.3342], timestamp: 0)
        let remoteService = CurrencyAPIMock(currencyRates: response)
        
        presenter = CurrencyListPresenterMock()
        interactor = CurrencyListInteractor(presenter: presenter,
                                            remoteService: remoteService,
                                            storeService: makeStoreService())
        
        let expectation = expectation(description: "Should fetch currency rates for added pair")
        presenter.expectation = expectation
        
        interactor.getCurrencyRateForAddedPair(pair)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testCurrencyListShouldShowPairWithoutRateWhenFailedToFetchRate() {
        let pair = CurrencyPairDTO(base: "USD", baseDescription: "United States Dollar",
                                   secondary: "RUB", secondaryDescription: "Russian Ruble")
        let storeService = makeStoreService()
        storeService.add(base: pair.base, baseName: pair.baseDescription,
                         secondary: pair.secondary, secondaryName: pair.secondaryDescription)
        let remoteService = CurrencyAPIMock(networkError: .timeOut)
        
        presenter = CurrencyListPresenterMock()
        interactor = CurrencyListInteractor(presenter: presenter,
                                            remoteService: remoteService,
                                            storeService: storeService)
        
        let expectation = expectation(description: "Should throw time out error")
        presenter.expectation = expectation
        
        interactor.getCurrencySymbolsAndRates()
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testCurrencyListShouldShowLoadingWhenFetchingCurrencies() {
        presenter = CurrencyListPresenterMock()
        interactor = CurrencyListInteractor(presenter: presenter,
                                            remoteService: APIClient(),
                                            storeService: makeStoreService())
        
        let expectation = expectation(description: "Should show loading when fetching list of currencies on launch")
        presenter.expectation = expectation
        
        interactor.getCurrencySymbolsAndRates()
        
        wait(for: [expectation], timeout: 2)
    }

}

extension CurrencyListInteractorTests {
    func makeStoreService() -> CurrencyStoreService {
        let coreDataStack = CoreDataStackMock()
        return CurrencyStoreService(managedObjectContext: coreDataStack.mainContext,
                                    coreDataStack: coreDataStack)
    }
}
