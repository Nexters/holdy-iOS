//
//  RewardDetailRouter.swift
//  holdy-iOS
//
//  Created by 양호준 on 2022/10/02.
//

import Foundation

import Alamofire
import RxSwift

struct RewardDetailRouter {
    func requestRewardDetail<T: Decodable>(api: Gettable, decodingType: T.Type) -> Single<T> {
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
}
