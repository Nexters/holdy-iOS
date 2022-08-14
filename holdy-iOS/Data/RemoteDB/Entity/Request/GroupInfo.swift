//
//  GroupInfo.swift
//  holdy-iOS
//
//  Created by Ellen on 2022/08/15.
//

import Foundation

class GroupInfo: Codable {
    let id: Int
    let startDate: String
    let endDate: String
    let place: PlaceInfo
    let host: HostInfo
    let loginUser: LoginUser
    let isEnd: Bool
    let participants: [UserInfo]
}

class HostInfo: Codable {
    let nickname: String
}

class LoginUser: Codable {
    let isHost: Bool
    let wantToAttend: Bool
}

class PlaceInfo: Codable {
    let summary: String
    let address: String
    let mapLink: String
}

class UserInfo: Codable {
    let id: Int
    let nickname: String
    let group: String
    let attend: Bool
}
