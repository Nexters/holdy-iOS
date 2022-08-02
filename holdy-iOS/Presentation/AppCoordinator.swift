//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

final class AppCoordinator: CoordinatorDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorDescribing]()
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        showHomeTabBarViewController()
    }
    
    private func showHomeTabBarViewController() {
        guard let loginTime = UserDefaults.standard.value(forKey: "loginTime") as? Date else {
            startLoginCoordinator()
            return
        }
        let loginTimeElapsedOneHour = loginTime + 3600
        
        if loginTimeElapsedOneHour < Date() {
            startLoginCoordinator()
        }
    }
}

extension AppCoordinator {
    private func startLoginCoordinator() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    private func startHomeCoordinator() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
