//
//  Created by 양호준 on 2022/08/09.
//

import Foundation

import Alamofire
import RxSwift

struct GeneratingGroupRouter {
    func requestGeneratingGroup<T: Decodable>(
        api: Requestable,
        startDate: String,
        endDate: String,
        summary: String,
        address: String,
        mapLink: String,
        decodingType: T.Type
    ) -> Single<T> {
        return Single.create { emitter in
            let loginSessionValue = String(describing: UserDefaultsManager.loginSession)
            let headers: HTTPHeaders = [
                "Accept": api.contentType ?? "",
                "Cookie": "SESSION=\(loginSessionValue)"
            ]
            let httpMethod = HTTPMethod(rawValue: api.method.description)
            let bodyParams: Parameters = [
                "startDate": startDate,
                "endDate": endDate,
                "place": [
                    "summary": summary,
                    "address": address,
                    "mapLink": mapLink
                ]
            ]
            
            AF
                .request(
                    api.url ?? URL(fileURLWithPath: ""),
                    method: httpMethod,
                    parameters: bodyParams,
                    encoding: JSONEncoding.default,
                    headers: headers
                )
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        emitter(.success(data))
                    case .failure(let error):
                        emitter(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
}
