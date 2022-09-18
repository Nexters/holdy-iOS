//
//  ReportResponse.swift
//  holdy-iOS
//
//  Created by 양호준 on 2022/09/18.
//

import Foundation

struct ReportResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: GroupID?
}

struct GroupID: Decodable {
    let id: Int
}
