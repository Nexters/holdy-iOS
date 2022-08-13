//
//  Created by 양호준 on 2022/08/04.
//

import UIKit

final class GeneratingGroupCoordinator: CoordinatorDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorDescribing]()
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        presentGeneratingGroupViewController()
    }
    
    private func presentGeneratingGroupViewController() {
        guard let navigationController = navigationController else { return }
        
        let generatingGroupViewController = GeneratingGroupViewController()
        generatingGroupViewController.modalPresentationStyle = .fullScreen
        navigationController.present(generatingGroupViewController, animated: true)
    }
}