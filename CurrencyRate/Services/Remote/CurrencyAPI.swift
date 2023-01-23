
import Foundation

protocol CurrencyAPI {
    func fetchCurrencyRate(base: String,
                           symbols: String,
                           completion: @escaping ParsedCompletion<CurrencyRateResponse>)
    func fetchCurrencySymbols(completion: @escaping ParsedCompletion<CurrencySymbolResponse>)
}

extension APIClient: CurrencyAPI {
    func fetchCurrencyRate(base: String,
                           symbols: String,
                           completion: @escaping ParsedCompletion<CurrencyRateResponse>) {
        makeAPIRequest(.rates(base: base, symbols: symbols), completion: completion)
    }
    
    func fetchCurrencySymbols(completion: @escaping ParsedCompletion<CurrencySymbolResponse>) {
        makeAPIRequest(.symbols, completion: completion)
    }
}
