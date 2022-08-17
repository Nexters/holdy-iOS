//
//  Created by Ellen on 2022/08/14.
//  Modified by 양호준 on 2022/08/16.
//

import Foundation

import RxCocoa
import RxSwift

final class GroupListViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let groupInfos: Observable<[GroupInfo]>
    }
    
    private let router = GroupListRouter()
    
    func transform(_ input: Input) -> Output {
        let groupInfos = configureGroupInfos(with: input.viewDidLoad)
        let output = Output(
            groupInfos: groupInfos
        )
        
        return output
    }
    
    private func configureGroupInfos(with inputObserver: Observable<Void>) -> Observable<[GroupInfo]> {
        inputObserver
            .withUnretained(self)
            .flatMap { (viewModel, _) -> Single<GroupInfoResponse> in
                let response = viewModel.router.requestGroupList(
                    api: HoldyAPI.GetGroupList(),
                    decodingType: GroupInfoResponse.self
                )
                
                return response
            }
            .map { groupInfoResponse in
                return groupInfoResponse.data
            }
    }
}
