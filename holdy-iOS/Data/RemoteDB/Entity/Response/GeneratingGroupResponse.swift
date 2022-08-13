//
//  Created by 양호준 on 2022/08/13.
//

import Foundation

struct GeneratingGroupResponse: Decodable {
    struct UserInfo: Decodable {
        let id: Int
    }
    
    let statusCode: Int
    let message: String?
    
}
