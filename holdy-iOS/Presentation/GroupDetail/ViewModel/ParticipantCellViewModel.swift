//
//  Created by 양호준 on 2022/10/24.
//

import Foundation
import RxSwift

final class ParticipantCellViewModel {
    struct Input {
        let participantButtonDidTap: Observable<Int>
    }
    
    struct Output {
        let response: Observable<Response>
        
        typealias Response = (message: String?, isAttended: Bool)
    }
    
    private let router = GroupDetailRouter()
    private var isAttended: Bool = true
    
    func transform(_ input: Input) -> Output {
        let response = configureParticipantButtonAction(with: input.participantButtonDidTap)
        
        let ouput = Output(response: response)
        
        return ouput
    }
    
    private func configureParticipantButtonAction(
        with inputObserver: Observable<Int>
    ) -> Observable<Output.Response> {
        inputObserver
            .withUnretained(self)
            .flatMap { viewModel, userID in
                viewModel.router.requestAttendanceCheck(
                    api: HoldyAPI.RequestAttendanceCheck(
                        groupID: GroupDetailViewModel.groupID,
                        userID: userID
                    ),
                    attend: viewModel.isAttended,
                    decodingType: ParticipantResponse.self
                )
            }
            .withUnretained(self)
            .map { viewModel, response in
                if response.data == nil {
                    return (response.message, viewModel.isAttended)
                }
                            
                viewModel.isAttended.toggle()
                
                return (nil, viewModel.isAttended)
            }
            
    }
}
