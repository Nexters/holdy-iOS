//
//  Created by 양호준 on 2022/08/17.
//

import UIKit

final class GroupDetailCoordinator: CoordinatorDescribing, NetworkEssentialDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: CoordinatorDescribing?
    var childCoordinators = [CoordinatorDescribing]()
    private var viewModel: GroupDetailViewModel!
    
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

    func setupGroupDetailViewModel(id: Int) {
        viewModel = GroupDetailViewModel(id: id)
    }
    
    private func presentGroupDetailViewController() {
        guard let navigationController = navigationController else { return }

        let groupDetailViewController = GroupDetailViewController(viewModel: viewModel, coordinator: self)

        groupDetailViewController.modalPresentationStyle = .fullScreen
        navigationController.present(groupDetailViewController, animated: true)
    }
}
