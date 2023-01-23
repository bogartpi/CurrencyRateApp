
import XCTest
@testable import CurrencyRate
import CoreData

class CurrencyStoreServiceTests: XCTestCase {

    var storeService: CurrencyStoreService!
    var coreDataStack: TestCoreDataStack!
    
    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
        storeService = CurrencyStoreService(managedObjectContext: coreDataStack.mainContext,
                                            coreDataStack: coreDataStack)
    }

    override func tearDownWithError() throws {
        storeService = nil
        coreDataStack = nil
    }
    
    func testFetchSymbols() {
        let symbolsDict = [
            "USD": "United States Dollar",
            "RUB": "Russian Ruble",
            "EUR": "Euro"
        ]
        storeService.add(symbols: symbolsDict)
        let symbols = storeService.fetchSymbols()
        
        XCTAssertEqual(symbols.count, symbolsDict.count)
        let symbol = symbols.first(where: { $0.abbreviation == "EUR" })
        XCTAssertNotNil(symbol)
        XCTAssertEqual(symbol?.abbreviation, "EUR")
        XCTAssertEqual(symbol?.name, "Euro")
    }
    
    func testDeleteCurrencyPair() {
        let currencyPair = storeService.add(base: "EUR", baseName: "Euro",
                                            secondary: "NZD", secondaryName: "New Zealand Dollar")
        var pairs = storeService.fetchPairs()
        XCTAssertTrue(pairs.count == 1)
        XCTAssertEqual(currencyPair.timestamp, pairs.first?.timestamp)
        XCTAssertEqual(currencyPair.base, pairs.first?.base)
        XCTAssertEqual(currencyPair.secondary, pairs.first?.secondary)
        
        storeService.delete(base: pairs.first!.base!, secondary: pairs.first!.secondary!)
        
        pairs = storeService.fetchPairs()
        XCTAssertTrue(pairs.count == 0)
    }

    func testAddCurrencyPair() {
        let currencyPair = storeService.add(base: "RUB", baseName: "Russian Ruble",
                                            secondary: "USD", secondaryName: "United States Dollar")
        
        XCTAssertNotNil(currencyPair)
        XCTAssertEqual(currencyPair.base, "RUB")
        XCTAssertEqual(currencyPair.baseName, "Russian Ruble")
        XCTAssertEqual(currencyPair.secondary, "USD")
        XCTAssertEqual(currencyPair.secondaryName, "United States Dollar")
        XCTAssertNotNil(currencyPair.timestamp)
    }
    
    func testShouldSaveContextWhenAddedCurrencyPair() {
        let context = coreDataStack.newDerivedContext
        storeService = CurrencyStoreService(managedObjectContext: context, coreDataStack: coreDataStack)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.mainContext) { _ in
            return true
        }
        
        context.perform {
            let pair = self.storeService.add(base: "NZD", baseName: "New Zealand Dollar",
                                             secondary: "RUB", secondaryName: "Russian Ruble")
            XCTAssertNotNil(pair)
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Couldn't save data")
        }
        
    }

}

