//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    private let router = InvitationpRouter()
    private let disposeBag = DisposeBag()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
    }

    // MARK: - Scene Lifecycle
    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    // MARK: - Kakao Link
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            let query = url.query
            if let range = query?.range(of: "="), var query = query {
                query.removeSubrange(query.startIndex...range.lowerBound)
                
                guard let id = Int(query) else { return }
                
                let response = router.reqeustInvitation(
                    api: HoldyAPI.RequestInvitaion(),
                    id: id,
                    decodingType: InvitaionResponse.self
                )
                
                response.asObservable()
                    .subscribe(onNext: { response in
                        #if DEBUG
                        print(response)
                        #endif
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
}
