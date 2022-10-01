//
//  Created by 양호준 on 2022/10/01.
//

import Foundation

struct RewardResponse: Decodable {
    let statusCode: Int
    let message: String?
    let data: [RewardInfo]
}

struct RewardInfo: Decodable {
    let id: Int?
    let startDate: String?
    let endDate: String?
    let place: PlaceInfo?
    let host: HostInfo?
    let loginUser: LoginUser?
    let isEnd: Bool?
    let participants: [UserInfo]?
}
