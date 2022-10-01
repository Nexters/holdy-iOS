//
//  Created by 양호준 on 2022/10/01.
//

import UIKit

import SnapKit
import Then

final class RewardHoldCell: UICollectionViewCell {
    private let holdImageView = UIImageView().then {
        $0.image = UIImage(named: "empty_hold")
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        holdImageView.image = UIImage(named: "empty_hold")
    }
    
    private func render() {
        self.add(holdImageView)
        
        holdImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(80)
        }
    }
    
    func configureContent(image: UIImage?) {
        holdImageView.image = image
    }
}
