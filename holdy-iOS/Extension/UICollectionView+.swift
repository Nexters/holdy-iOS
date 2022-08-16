import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellClass: T.Type) {
        let reuseIdentifier = String(describing: cellClass.self)
        
        register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
