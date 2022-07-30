//
//  Created by Ellen on 2022/07/20.
//

import Foundation
import Alamofire

enum HoldyAPI {
    #if DEBUG
    static let baseURL = "http://api-dev.semonemo.xyz/"
    #else
    static let baseURL = "https://api.semonemo.xyz/"
    #endif
    
    case requestLogin
    case getGroupList
    case getUserInfo(id: String)
    
    var request: (url: String, method: HTTPMethod, contentType: String?, body: Data?) {
        switch self {
        case .requestLogin:
            return (
                url: HoldyAPI.baseURL + "/api/login",
                method: .post,
                contentType: "application/json",
                body: nil
            )
        case .getGroupList:
            return (
                url: HoldyAPI.baseURL + "api/meetings",
                method: .get,
                contentType: nil,
                body: nil
            )
        case .getUserInfo(let id):
            return (
                url: HoldyAPI.baseURL + "api/users/\(id)",
                method: .get,
                contentType: nil,
                body: nil
            )
        }
    }
}
