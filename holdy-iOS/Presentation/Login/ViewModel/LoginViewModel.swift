//
//  Created by 양호준 on 2022/08/01.
//

import Foundation

import RxCocoa
import RxSwift

final class LoginViewModel {
    struct Input {
        let inputText: Observable<String>
        let loginButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let textFieldDidReturn: Driver<Void>
        let loginResponse: Driver<LoginResponse>
    }
    
    private let baseRouter = BaseRouter()
    private var inputText = ""
    
    func transform(_ input: Input) -> Output {
        let textFieldDidReturn = recognizeInputText(with: input.inputText)
        let loginResponse = requestLogin(with: input.loginButtonDidTap)
        
        let ouput = Output(
            textFieldDidReturn: textFieldDidReturn,
            loginResponse: loginResponse
        )
        
        return ouput
    }
    
    private func recognizeInputText(with input: Observable<String>) -> Driver<Void> {
        input
            .withUnretained(self)
            .map { (self, inputText) in
                self.inputText = inputText
            }
            .asDriver(onErrorJustReturn: ())
            
    }
    
    private func requestLogin(with input: Observable<Void>) -> Driver<LoginResponse> {
        input
            .withUnretained(self)
            .flatMap { _ in
                self.baseRouter.requestLogin(
                    api: HoldyAPI.RequestLogin(),
                    authKey: self.inputText,
                    decodingType: LoginResponse.self
                )
            }
            .asDriver(
                onErrorJustReturn: LoginResponse(
                    result: "HTTP Status Code Error",
                    loginUser: nil
                )
            )
    }
}
