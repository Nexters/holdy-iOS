//
//  Created by Ellen on 2022/07/20.
//  Modified by 양호준 on 2022/07/31.
//

import Foundation

import Alamofire

struct HoldyAPI {
    #if DEBUG
    static let baseURL = "http://api-dev.semonemo.xyz/"
    #else
    static let baseURL = "http://api-dev.semonemo.xyz/"
    #endif
    
    struct RequestLogin: Postable {
        var url: URL? = URL(string: HoldyAPI.baseURL + "api/login")
        var method: HttpMethod = .post
        var contentType: String? = "application/json"
        var body: Data?
    }
    
    struct GeneratingGroup: Postable {
        var url: URL? = URL(string: HoldyAPI.baseURL + "api/meetings")
        var method: HttpMethod = .post
        var contentType: String? = "application/json"
        var body: Data?
    }
    
    struct DeletingGroup: Deletable {
        var url: URL?
        var method: HttpMethod = .delete
        var contentType: String? = "application/json"
        var body: Data?
        
        init(id: String) {
            self.url = URL(string: HoldyAPI.baseURL + "api/meetings/\(id)")
        }
    }
    
    struct GetGroupList: Gettable {
        var url: URL? = URL(string: HoldyAPI.baseURL + "api/meetings")
        var method: HttpMethod = .get
    }
    
    struct GetGroupDetail: Gettable {
        var url: URL?
        var method: HttpMethod = .get
        
        init(id: Int) {
            self.url = URL(string: HoldyAPI.baseURL + "api/meetings/\(id)")
        }
    }

    struct RequestInvitaion: Postable {
        var url: URL? = URL(string: HoldyAPI.baseURL + "api/invitations")
        var method: HttpMethod = .post
        var contentType: String? = "application/json"
        var body: Data?
    }

    struct RequestAttendance: Puttable {
        let id: Int
        var url: URL?
        var method: HttpMethod = .put
        var contentType: String? = "application/json"
        var body: Data?

        init(id: Int) {
            self.id = id
            self.url  = URL(string: HoldyAPI.baseURL + "api/meetings/\(id)/attendance")
        }
    }

    struct RequestAttendanceCheck: Puttable {
        let groupID: Int
        let userID: Int
        var url: URL?
        var method: HttpMethod = .put
        var contentType: String? = "application/json"
        var body: Data?

        init(groupID: Int, userID: Int) {
            self.groupID = groupID
            self.userID = userID
            self.url = URL(string: HoldyAPI.baseURL + "api/meetings/\(groupID)/users/\(userID)/attendance")
        }
    }
    
    struct RequestReport: Postable {
        var url: URL? = URL(string: HoldyAPI.baseURL + "api/blacklist")
        var method: HttpMethod = .post
        var contentType: String? = "application/json"
        var body: Data?
    }
    
    struct RequestRewardList: Gettable {
        var url: URL? = URL(string: HoldyAPI.baseURL + "api/stamps")
        var method: HttpMethod = .get
    }
    
    struct RequestRewardDetail: Gettable {
        let id: Int
        
        var url: URL?
        var method: HttpMethod = .get
        
        init(id: Int) {
            self.id = id
            self.url = URL(string: HoldyAPI.baseURL + "api/stamps/\(id)")
        }
    }
}
