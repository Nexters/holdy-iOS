//
//  Created by 양호준 on 2022/10/02.
//

import UIKit

import RxSwift

final class RewardDetailViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let info: Observable<Info>
    }
    
    typealias Info = (image: UIImage?, place: String, date: Date?)
    
    private let selectedInfo: RewardViewModel.SelectedInfo
    private let router = RewardDetailRouter()
    
    init(selectedInfo: RewardViewModel.SelectedInfo) {
        self.selectedInfo = selectedInfo
    }
    
    func transform(_ input: Input) -> Output {
        let info = configureInfo(with: input.viewDidLoad)
        let ouput = Output(info: info)

        return ouput
    }

    private func configureInfo(with inputObserver: Observable<Void>) -> Observable<Info> {
        inputObserver
            .withUnretained(self)
            .flatMap { viewModel, _ -> Single<RewardDetailResponse> in
                viewModel.router.requestRewardDetail(
                    api: HoldyAPI.RequestRewardDetail(id: viewModel.selectedInfo.id),
                    decodingType: RewardDetailResponse.self
                )
            }
            .withUnretained(self)
            .map { viewModel, response in
                let image = viewModel.selectedInfo.hold
                let place = response.data.place?.address ?? "장소 없음"
                let date = response.data.endDate ?? "\(Date())"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let convertedDate = dateFormatter.date(from: date)
                
                return (image: image, place: place, date: convertedDate)
            }
    }
}
