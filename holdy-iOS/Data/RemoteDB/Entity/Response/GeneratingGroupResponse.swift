//
//  Created by 양호준 on 2022/08/13.
//

import Foundation

//struct GeneratingGroupResponse: Decodable {
//    struct Place: Decodable {
//        let summary: String
//        let address: String
//        let mapLink: String
//    }
//
//    let startDate: String
//    let endDate: String
//    let place: Place
//}

struct GeneratingGroupResponse: Decodable {
    struct UserData: Decodable {
        let id: Int
    }
    
    let statusCode: Int
    let message: String?
    let data: UserData?
}
