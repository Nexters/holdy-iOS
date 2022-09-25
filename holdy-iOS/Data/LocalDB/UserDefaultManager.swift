//
//  Created by 양호준 on 2022/08/19.
//

import Foundation

struct UserDefaultsManager {
    static let loginSession = UserDefaults.standard.string(forKey: "loginSession") ?? ""
    static let id = UserDefaults.standard.integer(forKey: "id")
    static let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    static let group = UserDefaults.standard.string(forKey: "group") ?? ""
    static let profileImageUrl = UserDefaults.standard.string(forKey: "profileImageUrl") ?? ""
}
