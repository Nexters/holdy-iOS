//
//  Created by 양호준 on 2022/08/17.
//

import UIKit

final class GroupDetailCoordinator: CoordinatorDescribing, NetworkEssentialDescribing {
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
            presentGroupDetailViewController()
        } else {
            showPageAccordingToNetworkConnection(
                connectionAction: presentGroupDetailViewController,
                navigationController: navigationController
            )
        }
    }
    
    private func presentGroupDetailViewController() {
        guard let navigationController = navigationController else { return }
        
        // TODO: GruopDetail View를 띄울 수 있도록 변경
//        let generatingGroupViewModel = GeneratingGroupViewModel()
//        let generatingGroupViewController = GeneratingGroupViewController(
//            viewModel: generatingGroupViewModel,
//            coordinator: self
//        )
//        generatingGroupViewController.modalPresentationStyle = .fullScreen
//        navigationController.present(generatingGroupViewController, animated: true)
    }
}
