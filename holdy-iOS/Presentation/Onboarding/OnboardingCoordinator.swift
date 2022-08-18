//
//  Created by 양호준 on 2022/08/13.
//

import UIKit

final class OnboardingCoordinator: CoordinatorDescribing {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorDescribing]()
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        pushOnboardingViewController()
    }
    
    private func pushOnboardingViewController() {
        guard let navigationController = navigationController else { return }
        
        let firstPage = OnboardingContentViewController(
            image: Content.firstImage,
            description: Content.firstText
        )
        let secondPage = OnboardingContentViewController(
            image: Content.secondImage,
            description: Content.secondText
        )
        let thirdPage = OnboardingContentViewController(
            image: Content.thirdImage,
            description: Content.thirdText
        )
        let fourthPage = OnboardingContentViewController(
            image: Content.fourthImage,
            description: Content.fourthText
        )
        
        let onboardingPageViewController = OnboardingPageViewController(
            pages: [
                firstPage, secondPage, thirdPage, fourthPage
            ],
            coordinator: self
        )
        
        navigationController.pushViewController(onboardingPageViewController, animated: true)
    }
    
    func startLoginCoordinator() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isHidden = true
        
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
}

extension OnboardingCoordinator {
    enum Content {
        static let firstText = "클라이머를 위한\n출첵 서비스 홀디를 소개해요"
        static let firstImage = UIImage(named: "firstOnboarding")
        
        static let secondText = "모임을 만들고\n게스트를 초대할 수 있어요"
        static let secondImage = UIImage(named: "secondOnboarding")
        
        static let thirdText = "초대 받은 모임에\n참여 의사를 밝힐 수 있어요"
        static let thirdImage = UIImage(named: "thirdOnboarding")
        
        static let fourthText = "참여한 모임이 끝나면\n홀드를 얻고 자랑할 수 있어요"
        static let fourthImage = UIImage(named: "fourthOnboarding")
    }
}
