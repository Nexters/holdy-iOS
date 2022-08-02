//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

extension CALayer {
    enum ShadowDirection {
        case top, left, right, bottom
    }

    func applyShadow(
        direction: ShadowDirection,
        color: UIColor = .systemGray5,
        opacity: Float = 0.95,
        radius: CGFloat = 5.0
    ) {
        switch direction {
        case .top:
            applyShadow(offset: CGSize(width: 0, height: -1), color: color, opacity: opacity, radius: radius)
        case .left:
            applyShadow(offset: CGSize(width: -1, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            applyShadow(offset: CGSize(width: 1, height: 0), color: color, opacity: opacity, radius: radius)
        case .bottom:
            applyShadow(offset: CGSize(width: 0, height: 2), color: color, opacity: opacity, radius: radius)
        }
    }

    func applyShadow(
        offset: CGSize,
        color: UIColor = .systemGray5,
        opacity: Float = 0.95,
        radius: CGFloat = 5.0
    ) {
        self.masksToBounds = false
        self.shadowOffset = offset
        self.shadowColor = color.cgColor
        self.shadowOpacity = opacity
        self.shadowRadius = radius
    }
}
