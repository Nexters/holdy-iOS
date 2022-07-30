//
//  Created by 양호준 on 2022/07/30.
//

import UIKit

extension UIView {
    @discardableResult
    func add<T: UIView>(_ subview: T, then closure: ((T) -> Void)? = nil) -> T {
        addSubview(subview)
        closure?(subview)
        return subview
    }

    @discardableResult
    func adds<T: UIView>(_ subviews: [T], then closure: (([T]) -> Void)? = nil) -> [T] {
        subviews.forEach { addSubview($0) }
        closure?(subviews)
        return subviews
    }
}
