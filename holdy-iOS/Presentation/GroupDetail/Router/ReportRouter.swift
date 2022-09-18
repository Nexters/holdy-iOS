//
//  ReportRouter.swift
//  holdy-iOS
//
//  Created by 양호준 on 2022/09/18.
//

import Foundation

import Alamofire
import RxSwift

struct ReportRouter {
    func requestReport<T: Decodable>(
        api: Postable,
        groupID: Int,
        content: String,
        decodingType: T.Type
    ) -> Single<T> {
        return Single.create { emitter in
            let loginSession: String = UserDefaultsManager.loginSession
            let headers: HTTPHeaders = ["Cookie": "SESSION=\(loginSession)"]
            let httpMethod = HTTPMethod(rawValue: api.method.description)
            let bodyParams: Parameters = [
                "meetingId": groupID,
                "content": content
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
}
