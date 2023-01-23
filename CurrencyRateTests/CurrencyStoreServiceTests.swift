
import XCTest
@testable import CurrencyRate
import CoreData

class CurrencyStoreServiceTests: XCTestCase {

    var storeService: CurrencyStoreService!
    var coreDataStack: CoreDataStackMock!
    
    override func setUpWithError() throws {
        coreDataStack = CoreDataStackMock()
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
    
    func testFetchSymbolsInAlphabeticalOrder() {
        let symbolsDict = [
            "CYN": "Chinese Yuan",
            "AED": "United Arab Dirham",
            "BYR": "Belarusian Ruble"
        ]
        storeService.add(symbols: symbolsDict)
        let symbols = storeService.fetchSymbols()
        
        XCTAssertEqual(symbols.count, symbolsDict.count)
        let firstExpectedSymbol = symbols.first(where: { $0.abbreviation == "AED" })
        let lastExpectedSymbol = symbols.first(where: { $0.abbreviation == "CYN" })
        XCTAssertNotNil(firstExpectedSymbol)
        XCTAssertNotNil(lastExpectedSymbol)
        XCTAssertEqual(firstExpectedSymbol?.abbreviation, "AED")
        XCTAssertEqual(lastExpectedSymbol?.abbreviation, "CYN")
    }
    
    func testFetchCurrencyPairsWhereLastAddedShouldBeFirst() {
        let firstPair = storeService.add(base: "EUR", baseName: "Euro",
                                            secondary: "NZD", secondaryName: "New Zealand Dollar")
        let secondPair = storeService.add(base: "AED", baseName: "United Arab Dirham",
                                            secondary: "EUR", secondaryName: "Euro")
        let thirdPair = storeService.add(base: "BYR", baseName: "Euro",
                                         secondary: "NZD", secondaryName: "Belarusian Ruble")

        let pairs = storeService.fetchPairs()
        
        XCTAssertTrue(pairs.count == 3)
        XCTAssertEqual(pairs.first?.base, thirdPair.base)
        XCTAssertEqual(pairs[1].base, secondPair.base)
        XCTAssertEqual(pairs[2].base, firstPair.base)
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
        
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error, "Couldn't save data")
        }
        
    }

}

