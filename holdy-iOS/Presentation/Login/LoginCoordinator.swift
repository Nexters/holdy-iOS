//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

final class LoginCoordinator: CoordinatorDescribing, NetworkEssentialDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorDescribing]()
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if NetworkConnectionManager.shared.isCurrentlyConnected {
            pushLoginViewController()
        } else {
            showPageAccordingToNetworkConnection(
                connectionAction: pushLoginViewController,
                navigationController: navigationController
            )
        }
    }
    
    private func pushLoginViewController() {
        guard let navigationController = navigationController else { return }
        
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel, coordinator: self)
        navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension LoginCoordinator {
    func startHomeCoordinator() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        
        let homeCoordinator = HomeCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
