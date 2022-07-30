//
//  HomeCoordinator.swift
//  holdy-iOS
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
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
