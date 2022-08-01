//
//  Created by 양호준 on 2022/08/01.
//

import XCTest
@testable import holdy_iOS

import Alamofire
import RxSwift

class LoginAPITests: XCTestCase {
    var sut: BaseRouter!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = BaseRouter()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        disposeBag = nil
    }

    func test_BaseRouter의_requestLogin가_제대로_동작하는지() throws {
        let expectation = XCTestExpectation()
        let response = sut.requestLogin(
            api: HoldyAPI.RequestLogin(),
            authKey: "871f357a",
            decodingType: LoginResponse.self
        )
        response.asObservable()
            .subscribe(onNext: { response in
                XCTAssertEqual("SUCCESS", response.result)
                XCTAssertEqual("양호준", response.loginUser?.nickname)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_이상한_authKey를_넣는_경우_존재하지_않는_인증키인지_response로_알려주는지() {
        let expectation = XCTestExpectation()
        let response = sut.requestLogin(
            api: HoldyAPI.RequestLogin(),
            authKey: "aaaaaaaa",
            decodingType: LoginResponse.self
        )
        response.asObservable()
            .subscribe(onNext: { response in
                XCTAssertEqual("존재하지 않는 인증키 입니다. (authKey: aaaaaaaa)", response.result)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
}
