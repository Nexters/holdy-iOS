//
//  Created by 양호준 on 2022/08/18.
//

import Foundation

struct InvitaionResponse: Decodable {
    let statusCode: Int
    let message: String?
    let data: InviteInfo?
}

struct InviteInfo: Decodable {
    let id: Int
}
