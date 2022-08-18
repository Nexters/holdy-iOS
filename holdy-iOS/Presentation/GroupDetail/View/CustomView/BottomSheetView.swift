//
//  Created by 양호준 on 2022/08/18.
//

import UIKit

import SnapKit
import Then

//class PassThroughView: UIView {
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let hitView = super.hitTest(point, with: event)
//
//        return hitView == self ? nil : hitView // subView가 터치되는 경우 nil을 반환하도록 함.
//    }
//}

final class BottomSheetView {
    // MARK: - UI Components
    private let guestGuideContainer = UIView().then {
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let guestGuideIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_info")
    }

    private let guestGuideLabel = UILabel().then {
        let text = "모임 시간 동안 출석 체크할 수 있어요"
        let highlightedText = "출석 체크"
        let allRange = (text as NSString).range(of: text)
        let highlightedRange = (text as NSString).range(of: highlightedText)
        let mutableAttributedString = NSMutableAttributedString(string: text)
        mutableAttributedString.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.pretendard(family: .regular, size: 14),
            range: allRange
        )
        mutableAttributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.gray9,
            range: allRange
        )
        mutableAttributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.customRed,
            range: highlightedRange
        )
        $0.attributedText = mutableAttributedString
    }

    private let titleLabel = UILabel().then {
        $0.text = "모임 참여자"
        $0.textColor = .gray9
        $0.font = .pretendard(family: .semiBold, size: 18)
    }

    private let inviteButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_invite"), for: .normal)
    }

    private let attendanceButton = UIButton().then {
        $0.setTitle("갈게요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .medium, size: 16)

        $0.backgroundColor = .veryStrongBlue

        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
}
