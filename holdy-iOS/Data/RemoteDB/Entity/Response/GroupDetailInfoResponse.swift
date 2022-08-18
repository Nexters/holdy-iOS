//
//  Created by 양호준 on 2022/08/18.
//

import Foundation

struct GroupDetailInfoResponse: Decodable {
    let statusCode: Int
    let message: String?
    let data: GroupInfo
}
