//
//  Created by 양호준 on 2022/07/30.
//

import Foundation

import Alamofire
import RxSwift

struct BaseRouter {
    func fetchData<T: Decodable>(api: Gettable, decodingType: T.Type) -> Single<T> {
        return Single.create { emitter in
            let headers: HTTPHeaders = [
                //                "Cookie": UserDefaults.standard.
//                "Accept": api ?? ""
            ]
            let httpMethod = HTTPMethod(rawValue: api.method.description)
            
            AF
                .request(
                    api.url ?? URL(fileURLWithPath: ""),
                    method: httpMethod,
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
    
    func requestLogin<T: Decodable>(
        api: Requestable,
        authKey: String,
        decodingType: T.Type
    ) -> Single<T> {
        return Single.create { emitter in
            let headers: HTTPHeaders = [
                "Accept": api.contentType ?? ""
            ]
            let httpMethod = HTTPMethod(rawValue: api.method.description)
            let bodyParams: Parameters = [
                "authKey": authKey
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
                        UserDefaults.standard.set(response.response?.headers["Set-Cookie"], forKey: "loginSession")
                        UserDefaults.standard.set(Date(), forKey: "loginTime")
                        emitter(.success(data))
                    case .failure(let error):
                        emitter(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
}
