//
//  Created by Ellen on 2022/08/15.
//  Modified by 양호준 on 2022/08/16.
//

import Foundation

struct GroupInfoResponse: Decodable {
    let statusCode: Int
    let message: String?
    let data: [GroupInfo]
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

struct PlaceInfo: Decodable {
    let summary: String
    let address: String
    let mapLink: String
}

struct HostInfo: Decodable, ParticipantsDescribing {
    var id: Int
    var nickname: String
    var group: String
    var profileImageUrl: String
}

struct LoginUser: Decodable {
    let isHost: Bool
    let wantToAttend: Bool
}

struct UserInfo: Decodable, ParticipantsDescribing {
    var id: Int
    var nickname: String
    var group: String
    var attended: Bool
    var profileImageUrl: String
}
