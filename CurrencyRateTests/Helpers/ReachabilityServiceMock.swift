
import Foundation
@testable import CurrencyRate

final class ReachabilityServiceMock: ReachabilityServiceProtocol {
    var isConnected = true
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}
