//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

protocol CoordinatorDescribing: AnyObject {
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [CoordinatorDescribing] { get set }
    
    func start()
}
