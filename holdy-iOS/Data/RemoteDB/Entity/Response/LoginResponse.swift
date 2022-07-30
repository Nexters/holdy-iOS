//
//  Created by 양호준 on 2022/07/30.
//

import Foundation

struct LoginResponse: Decodable {
    struct UserInfo: Decodable {
        let nickname: String
    }
    
    let result: String
    let loginUser: UserInfo?
}
