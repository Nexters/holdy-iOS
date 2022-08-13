//
//  Created by 양호준 on 2022/08/13.
//

import XCTest
@testable import holdy_iOS

import RxSwift

class GeneratingGroupAPITests: XCTestCase {
    var sut: GeneratingGroupRouter!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = GeneratingGroupRouter()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        disposeBag = nil
    }

    func test_GenaratingGroupRouter의_requestGeneratingGroup이_제대로_동작하는지() throws {
        let expectation = XCTestExpectation()
        let response = sut.requestGeneratingGroup(
            api: HoldyAPI.GeneratingGroup(),
            startDate: "2022-07-29T15:00:00",
            endDate: "2022-07-29T18:00:00",
            summary: "상록이집",
            address: "상록이 집 주소",
            mapLink: "주소주소",
            decodingType: GeneratingGroupResponse.self
        )
        response.asObservable()
            .subscribe(onNext: { response in
                XCTAssertNotNil(response.place)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
}
