//
//  Created by 양호준 on 2022/08/18.
//

import UIKit

import SnapKit
import Then

final class ParticipantCell: UICollectionViewCell {
    // MARK: - UI Components
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }

    private let nameLabel = UILabel().then {
        $0.textColor = .gray9
        $0.font = .pretendard(family: .semiBold, size: 16)
    }

    private let groupLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = .pretendard(family: .regular, size: 12)
    }

    private let hostIcon = UIImageView().then {
        $0.image = UIImage(named: "icon_host_fill")
        $0.contentMode = .scaleAspectFit
    }

//    private let attendanceButton = UIButton().then {
//        $0.setTitle("", for: <#T##UIControl.State#>)
//    }
}
