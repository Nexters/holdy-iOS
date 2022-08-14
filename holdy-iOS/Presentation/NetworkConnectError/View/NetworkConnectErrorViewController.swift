//
//  Created by 양호준 on 2022/08/14.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class NetworkConnectErrorViewController: UIViewController {
     // MARK: - UI Components
    private let errorImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "holdy_error")
    }
    
    private let errorLabel = UILabel().then {
        $0.text = "인터넷 연결이 끊어졌어요\n네트워크를 확인하고 다시 시도해주세요"
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .pretendard(family: .regular, size: 18)
    }
    
    private let retryButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.setTitle("다시 시도", for: .normal)
        $0.setTitleColor(.gray6, for: .normal)
        $0.setTitleColor(.gray1, for: .highlighted)
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        bind()
    }
    
    // MARK: - Methods
    private func render() {
        view.backgroundColor = .white
        
        view.adds([
            errorImageView,
            errorLabel,
            retryButton
        ])
        
        errorImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(222)
            $0.width.equalTo(209)
            $0.height.equalTo(74)
        }
        
        errorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(errorImageView.snp.bottom).offset(30)
            $0.width.equalTo(279)
            $0.height.equalTo(50)
        }
        
        retryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(errorLabel.snp.bottom).offset(30)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
    }
    
    // MARK: - Binding Methods
    private func bind() {
        retryButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                if NetworkConnectionManager.shared.isCurrentlyConnected {
                    viewController.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
