//
//  Created by 양호준 on 2022/08/04.
//

import UIKit

final class GeneratingGroupCoordinator: CoordinatorDescribing, NetworkEssentialDescribing {
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
            presentGeneratingGroupViewController()
        } else {
            showPageAccordingToNetworkConnection(
                connectionAction: presentGeneratingGroupViewController,
                navigationController: navigationController
            )
        }
    }

    func end() {
        guard let homeCoordinator = parentCoordinator as? HomeCoordinator else { return }

        homeCoordinator.endCoordinator(self)
    }
    
    private func presentGeneratingGroupViewController() {
        guard let navigationController = navigationController else { return }
        
        let generatingGroupViewModel = GeneratingGroupViewModel()
        let generatingGroupViewController = GeneratingGroupViewController(
            viewModel: generatingGroupViewModel,
            coordinator: self
        )
        generatingGroupViewController.modalPresentationStyle = .fullScreen
        navigationController.present(generatingGroupViewController, animated: true)
    }
}
