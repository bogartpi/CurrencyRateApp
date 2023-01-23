
import Foundation
@testable import CurrencyRate

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
