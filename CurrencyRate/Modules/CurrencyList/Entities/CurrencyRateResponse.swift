
import Foundation

struct CurrencyRateResponse: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
    let timestamp: Int
}
