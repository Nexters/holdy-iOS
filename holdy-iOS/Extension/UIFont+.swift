//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

extension UIFont {
    enum Family {
        case thin, extraLight, light, regular, medium, semiBold, bold, extraBold, black
        
        var kind: String {
            switch self {
            case .thin:
                return "Thin"
            case .extraLight:
                return "ExtraLight"
            case .light:
                return "Light"
            case .regular:
                return "Regular"
            case .medium:
                return "Medium"
            case .semiBold:
                return "SemiBold"
            case .bold:
                return "Bold"
            case .extraBold:
                return "ExtraBold"
            case .black:
                return "Black"
            }
        }
        
        var defaultSize: CGFloat {
            switch self {
            case .thin:
                return 10
            case .extraLight:
                return 10
            case .light:
                return 10
            case .regular:
                return 14
            case .medium:
                return 16
            case .semiBold:
                return 18
            case .bold:
                return 40
            case .extraBold:
                return 45
            case .black:
                return 50
            }
        }
    }
    
    static func pretendard(family: Family = .medium, size: CGFloat = 12) -> UIFont {
        return UIFont(name: "Pretendard-\(family.kind)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func pretendardWithDefaultSize(family: Family = .medium) -> UIFont {
        return UIFont(
            name: "Pretendard-\(family.kind)",
            size: family.defaultSize
        ) ?? UIFont.systemFont(ofSize: family.defaultSize)
    }
    
    static func poppins(family: Family = .medium, size: CGFloat = 40) -> UIFont {
        return UIFont(name: "Poppins-\(family.kind)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
