//
//  Created by 양호준 on 2022/08/14.
//

import UIKit

final class NetworkConnectErrorCoordinator: CoordinatorDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorDescribing]()
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        presentNetworkConnectErrorViewController()
    }
    
    private func presentNetworkConnectErrorViewController() {
        guard let navigationController = navigationController else { return }
        
        let networkConnectErrorViewController = NetworkConnectErrorViewController()
        networkConnectErrorViewController.modalPresentationStyle = .fullScreen
        navigationController.present(networkConnectErrorViewController, animated: true)
    }
}
