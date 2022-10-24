//
//  Created by 양호준 on 2022/08/17.
//

import Foundation

import Alamofire
import RxSwift

struct GroupDetailRouter {
    func requestGroupDetail<T: Decodable>(api: Gettable, decodingType: T.Type) -> Single<T> {
            return Single.create { element in
                let loginSession: String =  UserDefaultsManager.loginSession
                let headers: HTTPHeaders = ["Cookie": "SESSION=\(loginSession)"]
                let httpMethod = HTTPMethod(rawValue: api.method.description)

                AF.request(
                    api.url ?? URL(fileURLWithPath: ""),
                    method: httpMethod,
                    headers: headers
                )
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        element(.success(data))
                    case .failure(let error):
                        element(.failure(error))
                    }
                }
                return Disposables.create()
            }
        }

    func requestInviteGroup<T: Decodable>(api: Postable, groupID: Int, decodingType: T.Type) -> Single<T> {
        return Single.create { emitter in
            let loginSession: String =  UserDefaultsManager.loginSession
            let headers: HTTPHeaders = ["Cookie": "SESSION=\(loginSession)"]
            let httpMethod = HTTPMethod(rawValue: api.method.description)
            let bodyParams: Parameters = [
                "meetingId": groupID
            ]

            AF.request(
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

    func requestAttendance<T: Decodable>(
        api: Puttable,
        wantToAttend: Bool,
        decodingType: T.Type
    ) -> Single<T> {
        return Single.create { emitter in
            let loginSession: String =  UserDefaultsManager.loginSession
            let headers: HTTPHeaders = ["Cookie": "SESSION=\(loginSession)"]
            let httpMethod = HTTPMethod(rawValue: api.method.description)
            let bodyParams: Parameters = [
                "wantToAttend": wantToAttend
            ]

            AF.request(
                api.url ?? URL(fileURLWithPath: ""),
                method: httpMethod,
                parameters: bodyParams,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate(statusCode: 200..<500)
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

    func requestAttendanceCheck<T: Decodable>(
        api: Puttable,
        attend: Bool,
        decodingType: T.Type
    ) -> Single<T> {
        return Single.create { emitter in
            let loginSession: String =  UserDefaultsManager.loginSession
            let headers: HTTPHeaders = ["Cookie": "SESSION=\(loginSession)"]
            let httpMethod = HTTPMethod(rawValue: api.method.description)
            let bodyParams: Parameters = [
                "attend": attend
            ]

            AF.request(
                api.url ?? URL(fileURLWithPath: ""),
                method: httpMethod,
                parameters: bodyParams,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate(statusCode: 200..<500)
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
