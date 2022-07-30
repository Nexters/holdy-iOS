import UIKit

protocol CoordinatorDescribing: AnyObject {
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [CoordinatorDescribing] { get set }
    
    func start()
}
