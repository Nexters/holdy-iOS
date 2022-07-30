//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class LoginViewController: UIViewController {
    private let titleLabel = UILabel().then {
        $0.text = "Holdy"
        $0.font = .pretendard(family: .semiBold, size: 24)
        $0.textAlignment = .center
    }
    
    private let codeTextFieldShadow = ShadowFilterView(corner: 8)
    private let codeTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "10자리 코드를 입력해주세요",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray5,
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray5.cgColor
        $0.layer.cornerRadius = 8
        
        $0.addLeftPadding()
        
        $0.clearButtonMode = .always
        $0.returnKeyType = .done
    }
    
    private let loginButtonShadow = ShadowFilterView(corner: 8)
    private let loginButton = UIButton().then {
        $0.backgroundColor = UIColor.customBlue
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardWithDefaultSize(family: .medium)
    }
    
    private let noCodeButton = UIButton().then {
        $0.setTitle("코드가 없어요", for: .normal)
        $0.setTitleColor(.gray6, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .regular, size: 12)
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        render()
    }
    
    private func render() {
        view.adds([
            titleLabel, codeTextFieldShadow, loginButtonShadow, noCodeButton
        ])
        codeTextFieldShadow.add(codeTextField)
        loginButtonShadow.add(loginButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.centerX.equalToSuperview()
        }
        
        codeTextFieldShadow.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(UIScreen.main.bounds.height * 234 / 667)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(48)
        }
        codeTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loginButtonShadow.snp.makeConstraints {
            $0.top.equalTo(codeTextFieldShadow.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(48)
        }
        loginButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        noCodeButton.snp.makeConstraints {
            $0.top.equalTo(loginButtonShadow.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(90)
            $0.height.equalTo(17)
        }
    }
}
