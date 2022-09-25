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
        $0.text = "holdy"
        $0.textColor = .strongBlue
        $0.font = .poppins(family: .semiBold, size: 40)
        $0.textAlignment = .center
    }
    
    private let codeTextFieldShadow = UIView().then {
        $0.backgroundColor = .white
        $0.layer.applyShadow(direction: .bottom, color: .systemGray5, opacity: 0.95, radius: 4)
        $0.layer.cornerRadius = 8
    }
    private let codeTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "10자리 코드를 입력해주세요",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray5,
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        $0.textColor = .black
        
        $0.font = .pretendardWithDefaultSize(family: .regular)
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 8
        
        $0.addLeftPadding()
        
        $0.clearButtonMode = .always
        $0.returnKeyType = .done
    }
    
    private let loginButtonShadow = UIView().then {
        $0.backgroundColor = .white
        $0.layer.applyShadow(direction: .bottom, color: .systemGray5, opacity: 1, radius: 4)
        $0.layer.cornerRadius = 8
    }
    private let loginButton = UIButton().then {
        $0.backgroundColor = UIColor.strongBlue
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardWithDefaultSize(family: .medium)
        $0.isUserInteractionEnabled = false
    }
    
    private let noCodeButton = UIButton().then {
        $0.setTitle("코드가 없어요", for: .normal)
        $0.setTitleColor(.gray6, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .regular, size: 12)
    }
    
    private let textFieldText = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    private var viewModel: LoginViewModel!
    private var coordinator: LoginCoordinator!
    
    // MARK: - Initializers
    convenience init(viewModel: LoginViewModel, coordinator: LoginCoordinator) {
        self.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        configureTextField()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        codeTextField.resignFirstResponder()
    }
    
    private func render() {
        view.backgroundColor = .white
        
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
    
    private func configureTextField() {
        codeTextField.delegate = self
    }
    
    private func bind() {
        let input = LoginViewModel.Input(
            inputText: textFieldText.asObservable(),
            loginButtonDidTap: loginButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configureTextField(output: output.textFieldDidReturn)
        requestLogin(output: output.loginResponse)
    }
    
    private func configureTextField(output: Driver<Void>) {
        output
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.codeTextField.attributedText = NSAttributedString(
                    string: self.codeTextField.text ?? "",
                    attributes: [
                        NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
                    ]
                )
                self.loginButton.isUserInteractionEnabled = true
            })
            .disposed(by: disposeBag)
    }
    
    private func requestLogin(output: Driver<LoginResponse>) {
        output
            .drive(onNext: { [weak self] loginResponse in
                guard let self = self else { return }
                
                guard loginResponse.message == nil else {
                    self.codeTextField.text = nil
                    self.showWrongCodeAlert()
                    
                    UserDefaults.standard.set(nil, forKey: "loginSession")
                    
                    return
                }
                
                UserDefaults.standard.set(loginResponse.data?.id, forKey: "id")
                UserDefaults.standard.set(loginResponse.data?.nickname, forKey: "nickname")
                UserDefaults.standard.set(loginResponse.data?.group, forKey: "group")
                UserDefaults.standard.set(loginResponse.data?.profileImageUrl, forKey: "profileImageUrl")
                
                self.coordinator.startHomeCoordinator()
            })
            .disposed(by: disposeBag)
    }
    
    private func showWrongCodeAlert() {
        let alert = UIAlertController(
            title: "존재하지 않는 코드입니다",
            message: "코드를 다시 확인해주세요",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldText.onNext(textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldText.onNext(textField.text ?? "")
        
        return true
    }
}
