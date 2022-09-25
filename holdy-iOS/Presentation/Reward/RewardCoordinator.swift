//
//  Created by 양호준 on 2022/09/25.
//

import UIKit

final class RewardCoordinator: CoordinatorDescribing, NetworkEssentialDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: CoordinatorDescribing?
    var childCoordinators = [CoordinatorDescribing]()
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        if NetworkConnectionManager.shared.isCurrentlyConnected {
            presentRewardViewController()
        } else {
            showPageAccordingToNetworkConnection(
                connectionAction: presentRewardViewController,
                navigationController: navigationController
            )
        }
    }
    
    private func presentRewardViewController() {
        guard let navigationController = navigationController else {
            return
        }
        
        let rewardViewController = RewardListViewController()
        
        rewardViewController.modalPresentationStyle = .fullScreen
        navigationController.present(rewardViewController, animated: true)
    }
}

extension RewardCoordinator {
    func startRewardShareCoordinator() {
        
    }
    
    func endRewardShareCoordinator(_ coodinator: CoordinatorDescribing) {
        guard let index = childCoordinators.firstIndex(where: { $0 === coodinator }) else {
            return
        }

        childCoordinators.remove(at: index)
    }
}
