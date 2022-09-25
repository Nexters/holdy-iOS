//
//  Created by 양호준 on 2022/09/25.
//

import UIKit

import FloatingPanel
import RxCocoa
import RxSwift
import SnapKit
import Then

final class RewardListViewController: UIViewController {
    // MARK: - UI Components
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_close_highlighted"), for: .normal)
        $0.setImage(UIImage(named: "icon_close"), for: .highlighted)
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 32
        $0.clipsToBounds = true
    }
    
    private let nicknameLabel = UILabel().then {
        $0.text = UserDefaultsManager.nickname
        $0.textColor = .white
        $0.font = .pretendard(family: .semiBold, size: 24)
    }
    
    private let groupLabel = UILabel().then {
        $0.text = UserDefaultsManager.group
        $0.textColor = .white
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        configureProfileImage()
    }
    
    private func render() {
        view.backgroundColor = .strongBlue
        
        view.adds([
            closeButton,
            profileImageView,
            nicknameLabel,
            groupLabel
        ])
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(84)
            $0.size.equalTo(64)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        groupLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
        }
    }
    
    private func configureProfileImage() {
        guard
            let url = URL(string: UserDefaultsManager.profileImageUrl),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else {
            return
        }
        
        profileImageView.image = image
    }

}
