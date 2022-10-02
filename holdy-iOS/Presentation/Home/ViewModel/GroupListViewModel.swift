//
//  Created by Ellen on 2022/08/14.
//  Modified by 양호준 on 2022/08/16.
//

import Foundation

import RxCocoa
import RxSwift

final class GroupListViewModel {
    struct Input {
        let loadDataWithViewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let groupInfos: Observable<[GroupInfo]>
    }
    
    private(set) var isFiltered = false
    private let router = GroupListRouter()
    
    func transform(_ input: Input) -> Output {
        let groupInfos = configureGroupInfos(with: input.loadDataWithViewWillAppear)
        let output = Output(
            groupInfos: groupInfos
        )
        
        return output
    }
    
    private func configureGroupInfos(with inputObserver: Observable<Bool>) -> Observable<[GroupInfo]> {
        inputObserver
            .withUnretained(self)
            .flatMap { (viewModel, isViewWillAppearCalled) -> Single<GroupInfoResponse> in
                if !isViewWillAppearCalled {
                    viewModel.isFiltered.toggle()
                }
                
                let response = viewModel.router.requestGroupList(
                    api: HoldyAPI.GetGroupList(),
                    decodingType: GroupInfoResponse.self
                )
                
                return response
            }
            .withUnretained(self)
            .map { viewModel, groupInfoResponse in
                if viewModel.isFiltered {
                    return groupInfoResponse.data.filter { groupInfo in
                        groupInfo.isEnd == false
                    }
                }
                
                return groupInfoResponse.data
            }
    }
}
