//
//  Created by 양호준 on 2022/09/16.
//

import Foundation

import RxCocoa
import RxSwift

final class ReportViewModel {
    struct Input {
        let firstCheckBoxDidTap: Observable<Void>
        let secondCheckBoxDidTap: Observable<Void>
        let thirdCheckBoxDidTap: Observable<Void>
        let fourthCheckBoxDidTap: Observable<String>
        let reportButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let firstCheckBoxDidTap: Observable<Void>
        let secondCheckBoxDidTap: Observable<Void>
        let thirdCheckBoxDidTap: Observable<Void>
        let fourthCheckBoxDidTap: Observable<Void>
        let selectedCheck: Driver<ReportResponse>
    }
    
    private let router = ReportRouter()
    
    private let groupID: Int
    private var selectedCheck: [String] = []
    private var isFirstChecked = false
    private var isSecondChecked = false
    private var isThirdChecked = false
    private var isFourthChecked = false
    
    init(groupID: Int) {
        self.groupID = groupID
    }
    
    func transform(_ input: Input) -> Output {
        let selectedCheck = configureReportButton(input.reportButtonDidTap)
        
        let ouput = Output(
            firstCheckBoxDidTap: configureFirstCheckBox(input.firstCheckBoxDidTap),
            secondCheckBoxDidTap: configureSecondCheckBox(input.secondCheckBoxDidTap),
            thirdCheckBoxDidTap: configureThirdCheckBox(input.thirdCheckBoxDidTap),
            fourthCheckBoxDidTap: configureFourthCheckBox(input.fourthCheckBoxDidTap),
            selectedCheck: selectedCheck
        )
        
        return ouput
    }
    
    private func configureFirstCheckBox(_ input: Observable<Void>) -> Observable<Void> {
        return input
            .withUnretained(self)
            .map({ viewModel, _ in
                if viewModel.isFirstChecked {
                    viewModel.selectedCheck = []
                } else {
                    viewModel.selectedCheck = []
                    viewModel.selectedCheck.append("모임 정보에 부적절한 내용이 포함되어 있어요")
                }
                
                viewModel.isFirstChecked.toggle()
            })
    }
    
    private func configureSecondCheckBox(_ input: Observable<Void>) -> Observable<Void> {
        return input
            .withUnretained(self)
            .map({ viewModel, _ in
                if viewModel.isFirstChecked {
                    viewModel.selectedCheck = []
                } else {
                    viewModel.selectedCheck = []
                    viewModel.selectedCheck.append("광고나 홍보를 위해 만들어진 모임이에요")
                }
                
                viewModel.isFirstChecked.toggle()
            })
    }
    
    private func configureThirdCheckBox(_ input: Observable<Void>) -> Observable<Void> {
        return input
            .withUnretained(self)
            .map({ viewModel, _ in
                if viewModel.isFirstChecked {
                    viewModel.selectedCheck = []
                } else {
                    viewModel.selectedCheck = []
                    viewModel.selectedCheck.append("실제로 이루어지지 않는 모임이에요")
                }
                
                viewModel.isFirstChecked.toggle()
            })
    }
    
    private func configureFourthCheckBox(_ input: Observable<String>) -> Observable<Void> {
        return input
            .withUnretained(self)
            .map({ viewModel, inputText in
                if viewModel.isFirstChecked {
                    viewModel.selectedCheck = []
                } else {
                    viewModel.selectedCheck = []
                    viewModel.selectedCheck.append(inputText)
                }
                
                viewModel.isFirstChecked.toggle()
            })
    }
    
    private func configureReportButton(_ input: Observable<Void>) -> Driver<ReportResponse> {
        input
            .withUnretained(self)
            .flatMap { (viewModel, _) -> Single<ReportResponse> in
                guard let content = viewModel.selectedCheck.first else {
                    return Single.just(ReportResponse(
                        statusCode: 400,
                        message: "제대로 이유가 선택되지 않았습니다.",
                        data: nil)
                    )
                }
                
                return viewModel.router.requestReport(
                    api: HoldyAPI.RequestReport(),
                    groupID: viewModel.groupID,
                    content: content,
                    decodingType: ReportResponse.self
                )
            }
            .asDriver(onErrorJustReturn: ReportResponse(
                statusCode: 400,
                message: "알 수 없는 에러",
                data: nil)
            )
    }
}
