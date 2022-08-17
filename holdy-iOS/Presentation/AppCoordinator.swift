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
        showHomeViewController()
    }
    
    private func showHomeViewController() {
        if FirstLaunchChecker.isFirstLaunched() {
            startOnboardingCoordinator()
        } else {
            guard UserDefaults.standard.value(forKey: "loginSession") != nil else {
                startLoginCoordinator()
                
                return
            }
            
            startHomeCoordinator()
        }
    }
}

extension AppCoordinator {
    private func startOnboardingCoordinator() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
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
