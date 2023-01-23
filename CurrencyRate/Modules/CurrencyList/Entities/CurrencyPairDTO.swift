
import Foundation

struct CurrencyPairDTO {
    let base: String
    let baseDescription: String
    var secondary: String
    var secondaryDescription: String
    var rate: String?
    var timestamp = Date()
}
