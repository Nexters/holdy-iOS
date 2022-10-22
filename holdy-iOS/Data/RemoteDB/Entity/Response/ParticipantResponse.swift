//
//  Created by 양호준 on 2022/10/22.
//

import Foundation

struct ParticipantResponse: Decodable {
    let statusCode: Int
    let message: String?
    let data: IDInfo?
}

struct IDInfo: Decodable {
    let id: Int
}
