//
//  HomeCoordinator.swift
//  holdy-iOS
//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

final class HomeCoordinator: CoordinatorDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorDescribing]()
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
    }
}
