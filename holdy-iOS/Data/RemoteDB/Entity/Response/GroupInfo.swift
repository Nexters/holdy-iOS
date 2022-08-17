//
//  Created by Ellen on 2022/08/15.
//  Modified by 양호준 on 2022/08/16.
//

import Foundation

struct GroupInfoResponse: Decodable {
    let statusCode: Int
    let message: String?
    let data: [GroupInfo]?
}

struct GroupInfo: Decodable {
    let id: Int
    let startDate: String
    let endDate: String
    let place: PlaceInfo
    let host: HostInfo
    let loginUser: LoginUser
    let isEnd: Bool
    let participants: [UserInfo]
}

struct HostInfo: Decodable {
    let id: Int
    let nickname: String
    let group: String
    let profileImageUrl: String
}

struct LoginUser: Decodable {
    let isHost: Bool
    let wantToAttend: Bool
}

struct PlaceInfo: Decodable {
    let summary: String
    let address: String
    let mapLink: String
}

struct UserInfo: Decodable {
    let id: Int
    let nickname: String
    let group: String
    let attended: Bool
    let profileImageUrl: String
}
