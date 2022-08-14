//
//  Created by 양호준 on 2022/08/14.
//

import Foundation
import UIKit

protocol NetworkEssentialDescribing {
    func showPageAccordingToNetworkConnection(
        connectionAction: () -> Void,
        navigationController: UINavigationController?
    )
}

extension NetworkEssentialDescribing {
    func showPageAccordingToNetworkConnection(
        connectionAction: () -> Void,
        navigationController: UINavigationController?
    ) {
        connectionAction()
        
        guard let navigationController = navigationController else { return }
        
        let networkConnectErrorCoordinator = NetworkConnectErrorCoordinator(
            navigationController: navigationController
        )
        
        networkConnectErrorCoordinator.start()
    }
}
