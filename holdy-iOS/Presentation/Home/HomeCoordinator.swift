//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

final class HomeCoordinator: CoordinatorDescribing, NetworkEssentialDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorDescribing]()
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        if NetworkConnectionManager.shared.isCurrentlyConnected {
            pushHomeViewController()
        } else {
            showPageAccordingToNetworkConnection(
                connectionAction: pushHomeViewController,
                navigationController: navigationController
            )
        }
    }
    
    private func pushHomeViewController() {
        guard let navigationController = navigationController else {
            return
        }
        
        let homeViewModel = GroupListViewModel()
        let homeViewController = GroupListViewController(viewModel: homeViewModel, coordinator: self)
        navigationController.pushViewController(homeViewController, animated: true)
    }
}

extension HomeCoordinator {
    func startGeneratingGruopCoordinator() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        
        let generatingGroupCoordinator = GeneratingGroupCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(generatingGroupCoordinator)
        generatingGroupCoordinator.parentCoordinator = self
        generatingGroupCoordinator.start()
    }

    func endGeneratingGroupCoordinator(_ coodinator: CoordinatorDescribing) {
        guard let index = childCoordinators.firstIndex(where: { $0 === coodinator }) else {
            return
        }

        childCoordinators.remove(at: index)
    }
    
    func startGroupDetailCoordinator(with item: Int) {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        
        let groupDetailCoordinator = GroupDetailCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(groupDetailCoordinator)
        groupDetailCoordinator.setupGroupDetailViewModel(id: item)
        groupDetailCoordinator.start()
    }
}
