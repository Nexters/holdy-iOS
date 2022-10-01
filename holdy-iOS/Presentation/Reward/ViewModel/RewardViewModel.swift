//
//  Created by 양호준 on 2022/10/01.
//

import UIKit

import RxCocoa
import RxSwift

final class RewardViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let holds: Observable<[UIImage?]>
    }
    
    private var router = RewardRouter()
    private let holds = [
        UIImage(named: "hold_1"),
        UIImage(named: "hold_2"),
        UIImage(named: "hold_3"),
        UIImage(named: "hold_4"),
        UIImage(named: "hold_5"),
        UIImage(named: "hold_6"),
        UIImage(named: "hold_7"),
        UIImage(named: "hold_8"),
        UIImage(named: "hold_9"),
        UIImage(named: "hold_10"),
        UIImage(named: "hold_11"),
        UIImage(named: "hold_12"),
        UIImage(named: "hold_13"),
        UIImage(named: "hold_14"),
        UIImage(named: "hold_15")
    ]
    
    func transform(_ input: Input) -> Output {
        let holds = configureRewardHolds(with: input.viewDidLoad)
        let ouput = Output(holds: holds)
        
        return ouput
    }
    
    private func configureRewardHolds(with inputObserver: Observable<Void>) -> Observable<[UIImage?]> {
        inputObserver
            .withUnretained(self)
            .flatMap { viewModel, _ -> Single<GroupInfoResponse> in
                let response = viewModel.router.requestRewardList(
                    api: HoldyAPI.RequestRewardList(),
                    decodingType: GroupInfoResponse.self
                )
                
                return response
            }
            .withUnretained(self)
            .map { viewModel, response in
                let rewardCount = response.data.count
                var rewards: [UIImage?] = []
                
                for _ in 0..<rewardCount {
                    let number = rewardCount % viewModel.holds.count
                    
                    rewards.append(viewModel.holds[number])
                }
                
                return rewards
            }
    }
}
