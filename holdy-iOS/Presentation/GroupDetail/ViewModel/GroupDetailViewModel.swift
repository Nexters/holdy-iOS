//
//  Created by 양호준 on 2022/08/18.
//

import Foundation

import RxCocoa
import RxSwift

final class GroupDetailViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let participantButtonDidTap: Observable<Void>
    }

    struct Output {
        let groupInfo: Driver<GroupInfo>
        let participantsInfo: Observable<[ParticipantsDescribing]>
        let participantButtonResponse: Observable<ParticipantResponse>
        
        typealias ParticipantResponse = (message: String?, wantToAttend: Bool)
    }

    // MARK: - Properties
    private let router = GroupDetailRouter()
    private let participantsObservable = PublishSubject<[ParticipantsDescribing]>()
    private var participantsInfo: [ParticipantsDescribing] = []
    private var wantToAttend = true
    private(set) var id: Int
    private(set) var hostID = 0
    private(set) var startDate = Date()

    init(id: Int) {
        self.id = id
    }

    func transform(_ input: Input) -> Output {
        let groupInfo = configureGroupInfo(with: input.viewDidLoad)
        let participantsInfo = participantsObservable.asObservable()
        let participantButtonResponse = configureParticipateButtonAction(with: input.participantButtonDidTap)
        let output = Output(
            groupInfo: groupInfo,
            participantsInfo: participantsInfo,
            participantButtonResponse: participantButtonResponse
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
                self.startDate = self.generateDate($0.data.startDate)
                
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
    
    private func generateDate(_ text: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date: Date = formatter.date(from: text) else { return Date() }
        return date
    }
    
    private func configureParticipateButtonAction(
        with inputObserver: Observable<Void>
    ) -> Observable<Output.ParticipantResponse> {
        inputObserver
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.router.requestAttendance(
                    api: HoldyAPI.RequestAttendance(id: UserDefaultsManager.id),
                    wantToAttend: viewModel.wantToAttend,
                    decodingType: ParticipantResponse.self
                )
            }
            .withUnretained(self)
            .map { viewModel, response in
                viewModel.wantToAttend.toggle()
                
                return (response.message, viewModel.wantToAttend)
            }
    }
}
