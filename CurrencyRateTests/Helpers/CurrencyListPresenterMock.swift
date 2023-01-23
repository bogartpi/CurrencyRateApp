
import XCTest
@testable import CurrencyRate

final class CurrencyListPresenterMock: CurrencyListInteractorToPresenterProtocol {
    var expectation: XCTestExpectation?
    
    func fetchedCurrencyPairs(_ pairs: [CurrencyPairDTO]) {
        XCTAssertTrue(pairs.count == 1)
        XCTAssertNotNil(pairs.first?.rate)
        expectation?.fulfill()
    }
    
    func fetchedAddedCurrencyPair(_ pair: CurrencyPairDTO) {
        XCTAssertNotNil(pair.rate)
        expectation?.fulfill()
    }
    
    func showEmptyState(_ message: Message) {
        XCTAssertNotNil(message.title)
        XCTAssertNotNil(message.body)
        expectation?.fulfill()
    }
    
    func deleteListRow(at index: Int) {
        XCTAssertTrue(index == 0)
        expectation?.fulfill()
    }
    
    func networkErrorThrown(_ error: NetworkError) {
        XCTAssertEqual(error, .timeOut)
        expectation?.fulfill()
    }
    
    func toggleLoading(_ isLoading: Bool) {
        XCTAssertTrue(isLoading)
        expectation?.fulfill()
    }
}
