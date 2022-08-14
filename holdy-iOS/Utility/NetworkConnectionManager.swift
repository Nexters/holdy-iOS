//
//  Created by 양호준 on 2022/08/14.
//

import Network

struct NetworkConnectionManager {
    static let shared = NetworkConnectionManager()
    let monitor = NWPathMonitor()
    var isCurrentlyConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    private init() { }
    
    func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
    }
}
