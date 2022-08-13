//
//  Created by 양호준 on 2022/08/04.
//

import Foundation

import RxCocoa
import RxSwift

final class GeneratingGroupViewModel {
    struct Input {
        let generatingGroupButtonDidTap: Observable<(
            startDate: String,
            endDate: String,
            summary: String,
            address: String,
            mapLink: String
        )>
    }
    
    struct Output {
        let generatesGroup: Driver<GeneratingGroupResponse>
    }
    
    private let router = GeneratingGroupRouter()
    
    func transform(_ input: Input) -> Output {
        let generatingGroupResponse = configureGeneratesGroup(with: input.generatingGroupButtonDidTap)
        let ouput = Output(generatesGroup: generatingGroupResponse)
        
        return ouput
    }
    
    private func configureGeneratesGroup(
        with inputObserver: Observable<(
            startDate: String,
            endDate: String,
            summary: String,
            address: String,
            mapLink: String
        )>
    ) -> Driver<GeneratingGroupResponse> {
        inputObserver
            .withUnretained(self)
            .flatMap { (viewModel, inputTexts) -> Single<GeneratingGroupResponse> in
                let (startDate, endDate, summary, address, mapLink) = inputTexts
                
                return viewModel.router.requestGeneratingGroup(
                    api: HoldyAPI.GeneratingGroup(),
                    startDate: startDate,
                    endDate: endDate,
                    summary: summary,
                    address: address,
                    mapLink: mapLink,
                    decodingType: GeneratingGroupResponse.self
                )
            }
            .asDriver(
                onErrorJustReturn: GeneratingGroupResponse(
                    statusCode: 200,
                    message: nil,
                    data: nil
                )
            )
    }
}
