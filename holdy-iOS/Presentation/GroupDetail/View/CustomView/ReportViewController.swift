//
//  Created by 양호준 on 2022/09/13.
//

import UIKit

import SnapKit
import Then

final class ReportViewController: UIViewController {
    private let bottomContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "모임을 신고하려는 이유를 알려주세요"
        $0.textColor = .gray9
        $0.font = .pretendard(family: .semiBold, size: 18)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "모임을 신고하면 모임을 더 이상 볼 수 없어요"
        $0.textColor = .gray6
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    private let firstCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "icon_check_square"), for: .normal)
//        $0.setImage(UIImage(named: "icon_check_selected_square"), for: .selected)
    }
    
    private let firstContent = UILabel().then {
        $0.text = "모임 정보에 부적절한 내용이 포함되어 있어요"
        $0.textColor = .gray9
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    private let secondCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "icon_check_square"), for: .normal)
//        $0.setImage(UIImage(named: "icon_check_selected_square"), for: .selected)
    }
    
    private let secondContent = UILabel().then {
        $0.text = "광고나 홍보를 위해 만들어진 모임이에요"
        $0.textColor = .gray9
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    private let thirdCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "icon_check_square"), for: .normal)
//        $0.setImage(UIImage(named: "icon_check_selected_square"), for: .selected)
    }
    
    private let thirdContent = UILabel().then {
        $0.text = "실제로 이루어지지 않는 모임이에요"
        $0.textColor = .gray9
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    private let fourthCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "icon_check_square"), for: .normal)
//        $0.setImage(UIImage(named: "icon_check_selected_square"), for: .selected)
    }
    
    private let fourthContent = UILabel().then {
        $0.text = "기타"
        $0.textColor = .gray9
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    private let reasonTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private let textNumberLabel = UILabel().then {
        $0.text = "0/100"
        $0.textColor = .gray5
        $0.font = .pretendard(family: .regular, size: 12)
        $0.textAlignment = .right
    }
    
    private let reportButton = UIButton().then {
        $0.setTitle("신고하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray6, for: .highlighted)
        
        $0.backgroundColor = .strongBlue
        
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    private func render() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
    }

}
