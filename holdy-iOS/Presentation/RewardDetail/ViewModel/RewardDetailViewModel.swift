//
//  Created by 양호준 on 2022/10/02.
//

import Foundation
import RxSwift

final class RewardDetailViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private let selectedInfo: RewardViewModel.SelectedInfo
    
    init(selectedInfo: RewardViewModel.SelectedInfo) {
        self.selectedInfo = selectedInfo
    }
    
//    func transform(_ input: Input) -> Output {
//        let ouput = Output()
//
//        return ouput
//    }
//
//    private func configure(with inputObserver: Observable<Void>) -> Observable<Void> {
//
//    }
}

