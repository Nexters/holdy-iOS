//
//  Created by 양호준 on 2022/08/01.
//

import Foundation

import RxCocoa
import RxSwift

final class LoginViewModel {
    struct Input {
        let inputText: Observable<String>
        let loginButtonDidTap: Observable<String>
    }
    
    struct Output {
        let textFieldDidReturn: Driver<Void>
        let loginResponse: Driver<LoginResponse>
    }
    
    private let baseRouter = LoginRouter()
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
    
    private func requestLogin(with input: Observable<String>) -> Driver<LoginResponse> {
        input
            .withUnretained(self)
            .flatMap { (viewModel, input) in
                viewModel.baseRouter.requestLogin(
                    api: HoldyAPI.RequestLogin(),
                    authKey: input,
                    decodingType: LoginResponse.self
                )
            }
            .asDriver(
                onErrorJustReturn: LoginResponse(
                    statusCode: 200,
                    message: "존재하지 않는 인증키 입니다.",
                    data: nil)
            )
    }
}
