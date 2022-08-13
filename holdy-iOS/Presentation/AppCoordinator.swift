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
            guard let loginTime = UserDefaults.standard.value(forKey: "loginTime") as? Date else {
                startLoginCoordinator()
                return
            }
            let loginTimeElapsedOneHour = loginTime + 3600
            
            if loginTimeElapsedOneHour < Date() {
                startLoginCoordinator()
            }
            
            startGeneratingGroupCoordinator()
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
    
    // TODO: Home화면 구현 완료되면 삭제
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
