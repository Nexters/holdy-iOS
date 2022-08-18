//
//  Created by 양호준 on 2022/08/18.
//

import UIKit

final class GroupDetailViewController: UIViewController {
    enum SheetMode {
        case common
        case full

        var ratio: CGFloat {
            switch self {
            case .common:
                return 0.5
            case .full:
                return 0
            }
        }
    }

    // MARK: - UI Components
    private let navigationView = GroupDetailNavigationView(frame: .zero)
//    private let participantsBottomSheet

    // MARK: - Gesture
//    private let panGesture = UIPanGestureRecognizer(target: self, action: <#T##Selector?#>)

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Gesture Action
    @objc
    private func didPan(_ recoginizer: UIPanGestureRecognizer) {
        // 움직인 거리
//        let translationY = recoginizer.translation(in: self)
    }
}
