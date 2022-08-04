//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

final class LoginCoordinator: CoordinatorDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorDescribing]()
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        pushLoginViewController()
    }
    
    private func pushLoginViewController() {
        guard let navigationController = navigationController else { return }
        
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel, coordinator: self)
        navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension LoginCoordinator {
    // TODO: HomeCoordinator로 옮기고 HomeCoordinator를 띄우는 함수로 대체 예정
    func startGeneratingGroupCoordinator() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        
        let generatingGroupCoordinator = GeneratingGroupCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(generatingGroupCoordinator)
        generatingGroupCoordinator.start()
    }
}
