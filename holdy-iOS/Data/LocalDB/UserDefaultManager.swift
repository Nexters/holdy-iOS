//
//  Created by 양호준 on 2022/08/19.
//

import Foundation

struct UserDefaultsManager {
    static let loginSession = UserDefaults.standard.string(forKey: "loginSession") ?? ""
    static let id = UserDefaults.standard.integer(forKey: "id")
}
