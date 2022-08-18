//
//  Created by 양호준 on 2022/08/18.
//

import UIKit

import SnapKit
import Then

final class GroupDetailNavigationView: UIView {
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_close_highlighted"), for: .normal)
        $0.setImage(UIImage(named: "icon_close"), for: .highlighted)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        render()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        adds([
            closeButton
        ])

        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }
}
