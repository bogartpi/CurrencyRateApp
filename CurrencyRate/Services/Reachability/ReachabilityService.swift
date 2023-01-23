
import Network

protocol ReachabilityServiceProtocol: AnyObject {
    var isConnected: Bool { get }
}

final class ReachabilityService: ReachabilityServiceProtocol {
    
    var isConnected: Bool = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    static let shared = ReachabilityService()
    
    private init() {
        monitor.start(queue: queue)
        updateConnectionStatus()
    }
    
    func updateConnectionStatus(handler: ((Bool) -> Void)? = nil) {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
            if let handler = handler {
                handler(self.isConnected)
            }
        }
    }
}
