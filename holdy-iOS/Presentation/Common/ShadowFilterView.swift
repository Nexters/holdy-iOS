//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

final class ShadowFilterView: UIView {
    enum ShadowState {
        case normal
        case selected
        case none
    }

    let corner: CGFloat

    var subLayer: CAGradientLayer?

    init(corner: CGFloat = 0.0) {
        self.corner = corner
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func changeShadow(state: ShadowState) {
        let shadowRadius = CGFloat(2.0)
        let caGradientLayer: CAGradientLayer = CAGradientLayer()

        if
            let subLayer = self.subLayer,
            let subLayers = self.layer.sublayers,
            let index = subLayers.firstIndex(of: subLayer) {
            self.layer.sublayers?.remove(at: index)
        }

        switch state {
        case .normal:
            caGradientLayer.colors = [
                UIColor.black.withAlphaComponent(0.0).cgColor,
                UIColor.black.withAlphaComponent(0.04).cgColor
            ]
            caGradientLayer.shadowRadius = shadowRadius
            caGradientLayer.cornerRadius = corner
            caGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            caGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            caGradientLayer.locations = [0.0, 1.0]

            caGradientLayer.frame = CGRect(
                x: 0.0,
                y: frame.height,
                width: frame.width,
                height: shadowRadius
            )
        case .selected:
            caGradientLayer.colors = [
                UIColor.black.withAlphaComponent(0.0).cgColor,
                UIColor.black.withAlphaComponent(0.08).cgColor
            ]
            caGradientLayer.shadowRadius = shadowRadius
            caGradientLayer.cornerRadius = corner
            caGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            caGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            caGradientLayer.locations = [0.0, 1.0]

            caGradientLayer.frame = CGRect(
                x: 0.0,
                y: frame.height,
                width: frame.width,
                height: shadowRadius
            )

        case .none:
            caGradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            caGradientLayer.shadowRadius = shadowRadius
            caGradientLayer.cornerRadius = corner
            caGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            caGradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            caGradientLayer.locations = [0.0, 0.0]

            caGradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: 0, height: shadowRadius)
        }

        subLayer = caGradientLayer
        layer.addSublayer(caGradientLayer)
    }
}
