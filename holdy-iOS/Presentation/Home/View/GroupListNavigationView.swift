//
//  Created by 양호준 on 2022/08/16.
//

import UIKit

import SnapKit
import Then

final class GroupListNavigationView: UIView {
    private let nameImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "holdy_black")
    }
    
    private let myInfoButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_holdy"), for: .normal)
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
            nameImageView,
            myInfoButton
        ])
        
        nameImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(90)
            $0.height.equalTo(32)
        }
        
        myInfoButton.snp.makeConstraints {
            $0.centerY.equalTo(nameImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(40)
        }
    }
}
