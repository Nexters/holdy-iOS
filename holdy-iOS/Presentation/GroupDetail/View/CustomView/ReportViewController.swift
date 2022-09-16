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
        $0.setTitle("모임 정보에 부적절한 내용이 포함되어 있어요", for: .normal)
        $0.setTitleColor(.gray9, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .regular, size: 14)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }
    
    private let secondCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "icon_check_square"), for: .normal)
        $0.setTitle("광고나 홍보를 위해 만들어진 모임이에요", for: .normal)
        $0.setTitleColor(.gray9, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .regular, size: 14)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }
    
    private let thirdCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "icon_check_square"), for: .normal)
        $0.setTitle("실제로 이루어지지 않는 모임이에요", for: .normal)
        $0.setTitleColor(.gray9, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .regular, size: 14)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }
    
    private let fourthCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "icon_check_square"), for: .normal)
        $0.setTitle("기타", for: .normal)
        $0.setTitleColor(.gray9, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .regular, size: 14)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }
    
    private let reasonTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.backgroundColor = .gray0
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
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        view.add(bottomContainerView)
        bottomContainerView.adds([
            titleLabel,
            descriptionLabel,
            firstCheckBox,
            secondCheckBox,
            thirdCheckBox,
            fourthCheckBox,
            reasonTextView,
            textNumberLabel,
            reportButton
        ])
        
        bottomContainerView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(470)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomContainerView.snp.top).inset(32)
            $0.leading.equalTo(bottomContainerView.snp.leading).inset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        firstCheckBox.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.equalTo(titleLabel.snp.leading).inset(8)
        }
        
        secondCheckBox.snp.makeConstraints {
            $0.top.equalTo(firstCheckBox.snp.bottom).offset(16)
            $0.leading.equalTo(titleLabel.snp.leading).inset(8)
        }
        
        thirdCheckBox.snp.makeConstraints {
            $0.top.equalTo(secondCheckBox.snp.bottom).offset(16)
            $0.leading.equalTo(titleLabel.snp.leading).inset(8)
        }
        
        fourthCheckBox.snp.makeConstraints {
            $0.top.equalTo(thirdCheckBox.snp.bottom).offset(16)
            $0.leading.equalTo(titleLabel.snp.leading).inset(8)
        }
        
        reasonTextView.snp.makeConstraints {
            $0.top.equalTo(fourthCheckBox.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(85)
        }
        
        textNumberLabel.snp.makeConstraints {
            $0.top.equalTo(reasonTextView.snp.bottom).offset(4)
            $0.trailing.equalTo(reasonTextView.snp.trailing)
        }
        
        reportButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textNumberLabel.snp.bottom).offset(40)
            $0.width.equalTo(335)
            $0.height.equalTo(48)
        }
    }
}
