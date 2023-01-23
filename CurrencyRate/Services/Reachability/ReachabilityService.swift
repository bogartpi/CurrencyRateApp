
import Network

protocol ReachabilityServiceProtocol: AnyObject {
    var isConnected: Bool { get }
}

final class ReachabilityService {
    
    var isConnected: Bool = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    static let shared = ReachabilityService()
    
    private init() {
        monitor.start(queue: queue)
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.updateConnectionStatus(path: path)
        }
    }
    
    private func updateConnectionStatus(path: NWPath) {
        let newConnectionStatus = path.status == .satisfied
        if isConnected != newConnectionStatus {
            self.isConnected = newConnectionStatus
        }
    }
}
