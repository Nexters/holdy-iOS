//
//  Created by 양호준 on 2022/10/02.
//

import UIKit

final class RewardDetailCoordinator: CoordinatorDescribing, NetworkEssentialDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: CoordinatorDescribing?
    var childCoordinators = [CoordinatorDescribing]()
    private let selectedInfo: RewardViewModel.SelectedInfo
    
    // MARK: - Initializers
    init(navigationController: UINavigationController, selectedInfo: RewardViewModel.SelectedInfo) {
        self.navigationController = navigationController
        self.selectedInfo = selectedInfo
    }
    
    // MARK: - Methods
    func start() {
        if NetworkConnectionManager.shared.isCurrentlyConnected {
            presentRewardDetailViewController()
        } else {
            showPageAccordingToNetworkConnection(
                connectionAction: presentRewardDetailViewController,
                navigationController: navigationController
            )
        }
    }
    
    func end() {
        guard let rewardCoordinator = parentCoordinator as? RewardCoordinator else { return }

        rewardCoordinator.endCoordinator(self)
    }
    
    private func presentRewardDetailViewController() {
        guard let navigationController = navigationController else {
            return
        }
        
        let viewController = RewardDetailViewController()
        
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }
}
