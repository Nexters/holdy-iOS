//
//  Created by 양호준 on 2022/08/18.
//

import Foundation

import RxCocoa
import RxSwift

final class GroupDetailViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
    }

    struct Output {
        let groupInfo: Driver<GroupInfo>
        let participantsInfo: Observable<[ParticipantsDescribing]>
    }

    // MARK: - Properties
    private let router = GroupDetailRouter()
    private let id: Int
    private let participantsObservable = PublishSubject<[ParticipantsDescribing]>()
    private var participantsInfo: [ParticipantsDescribing] = []
    private(set) var hostID = 0

    init(id: Int) {
        self.id = id
    }

    func transform(_ input: Input) -> Output {
        let groupInfo = configureGroupInfo(with: input.viewDidLoad)
        let participantsInfo = participantsObservable.asObservable()
        let output = Output(
            groupInfo: groupInfo,
            participantsInfo: participantsInfo
        )

        return output
    }

    private func configureGroupInfo(with inputObserver: Observable<Void>) -> Driver<GroupInfo> {
        inputObserver
            .withUnretained(self)
            .flatMap { (viewModel, _) -> Single<GroupDetailInfoResponse> in
                let response = viewModel.router.requestGroupDetail(
                    api: HoldyAPI.GetGroupDetail(id: viewModel.id),
                    decodingType: GroupDetailInfoResponse.self
                )

                return response
            }
            .map {
                self.hostID = $0.data.host.id
                self.participantsInfo.append($0.data.host)
                for participantInfo in $0.data.participants {
                    if participantInfo.id == $0.data.host.id {
                        break
                    }
                    
                    self.participantsInfo.append(participantInfo)
                }
                
                self.participantsObservable.onNext(self.participantsInfo)
                
                return $0.data
            }
            .asDriver(onErrorJustReturn:
                        GroupInfo(
                            id: 0,
                            startDate: "\(Date())",
                            endDate: "\(Date())",
                            place: PlaceInfo(summary: "", address: "", mapLink: ""),
                            host: HostInfo(id: 0, nickname: "", group: "", profileImageUrl: ""),
                            loginUser: LoginUser(isHost: false, wantToAttend: false),
                            isEnd: false,
                            participants: []
                        )
            )
    }
}
