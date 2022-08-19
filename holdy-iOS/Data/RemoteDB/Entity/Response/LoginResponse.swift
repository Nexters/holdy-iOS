//
//  Created by 양호준 on 2022/07/30.
//

import Foundation

struct LoginResponse: Decodable {
    struct UserInfo: Decodable {
        let id: Int
        let nickname: String
        let group: String
        let profileImageUrl: String
    }
    
    let statusCode: Int
    let message: String?
    let data: UserInfo?
}
