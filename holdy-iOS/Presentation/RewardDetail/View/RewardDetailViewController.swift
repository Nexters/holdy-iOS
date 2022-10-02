//
//  Created by 양호준 on 2022/10/02.
//

import UIKit

import SnapKit
import Then

final class RewardDetailViewController: UIViewController {
    // MARK: - UI Components
    private let backgroundView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "bg_reward_detail")
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_close_highlighted"), for: .normal)
        $0.setImage(UIImage(named: "icon_close"), for: .highlighted)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "모임에 참여하고 받은\n홀드를 자랑해보세요!"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .pretendard(family: .medium, size: 24)
        $0.numberOfLines = 0
    }
    
    private let holdImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let placeLabel = UILabel().then {
        $0.text = "장소"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .pretendard(family: .semiBold, size: 24)
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "날짜"
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.font = .pretendard(family: .regular, size: 16)
    }
    
    private let shareInstaButton = UIButton().then {
        $0.backgroundColor = .veryStrongBlue
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.setTitle("인스타그램에 공유하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray3, for: .highlighted)
        $0.titleLabel?.font = UIFont.pretendardWithDefaultSize(family: .medium)
        $0.isUserInteractionEnabled = true
    }
    
    private var viewModel: RewardDetailViewModel!
    
    convenience init(viewModel: RewardDetailViewModel) {
        self.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    // MARK: - Methods
    private func render() {
        view.backgroundColor = .black
        
        view.adds([
            backgroundView,
            closeButton,
            titleLabel,
            holdImageView,
            placeLabel,
            dateLabel,
            shareInstaButton
        ])
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(520)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(84)
            $0.centerX.equalToSuperview()
//            $0.height.equalTo(100)
        }
        
        holdImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(148)
        }
        
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(holdImageView.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        shareInstaButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(80)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(50)
        }
    }
}
