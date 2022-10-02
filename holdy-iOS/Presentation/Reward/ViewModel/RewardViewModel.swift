//
//  Created by 양호준 on 2022/10/01.
//

import UIKit

import RxCocoa
import RxSwift

final class RewardViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let cellSelected: Observable<IndexPath>
    }
    
    struct Output {
        let holds: Observable<[UIImage?]>
        let selectedInfo: Observable<SelectedInfo>
    }
    
    typealias SelectedInfo = (id: Int, hold: UIImage?)
    
    private var router = RewardRouter()
    private var ids = [Int]()
    private var rewards = [UIImage?]()
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
        let selectedInfo = configureSelectedIndex(with: input.cellSelected)
        let ouput = Output(holds: holds, selectedInfo: selectedInfo)
        
        return ouput
    }
    
    private func configureRewardHolds(with inputObserver: Observable<Void>) -> Observable<[UIImage?]> {
        inputObserver
            .withUnretained(self)
            .flatMap { viewModel, _ -> Single<RewardResponse> in
                let response = viewModel.router.requestRewardList(
                    api: HoldyAPI.RequestRewardList(),
                    decodingType: RewardResponse.self
                )
                
                return response
            }
            .withUnretained(self)
            .map { viewModel, response in
                let rewardCount = response.data.count
                var rewards: [UIImage?] = []
                
                for reward in response.data {
                    let rewardID = reward.id ?? 0
                    let index = rewardID % viewModel.holds.count
                    
                    viewModel.ids.append(rewardID)
                    rewards.append(viewModel.holds[index])
                }
                viewModel.rewards = rewards
                
                return rewards
            }
    }
    
    private func configureSelectedIndex(
        with inputObserver: Observable<IndexPath>
    ) -> Observable<SelectedInfo> {
        inputObserver
            .withUnretained(self)
            .filter { viewModel, indexPath in
                let index = indexPath.section * 4 - indexPath.section / 2 + indexPath.item
                
                return viewModel.ids.count > index
            }
            .map { viewModel, indexPath in
                let index = indexPath.section * 4 - indexPath.section / 2 + indexPath.item
                let id = viewModel.ids[index]
                let holdImage = viewModel.rewards[index]
                
                return (id: id, hold: holdImage)
            }
    }
}
