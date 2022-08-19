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
    
    private let participantButton = UIButton().then {
        $0.setTitle("안왔어요", for: .normal)
        $0.setTitleColor(.gray6, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .regular, size: 12)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray1
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
        
        profileImageView.image = nil
        nameLabel.text = nil
        groupLabel.text = nil
        hostIcon.isHidden = true
        participantButton.isHidden = false
    }
    
    // MARK: - Methods
    private func render() {
        adds([
            profileImageView,
            nameLabel,
            groupLabel,
            hostIcon,
            participantButton,
            dividerView
        ])
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(56)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        groupLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nameLabel.snp.leading)
        }
        
        hostIcon.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
            $0.width.equalTo(28)
            $0.height.equalTo(16)
        }
        
        participantButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(57)
            $0.height.equalTo(24)
        }
        
        dividerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configureContent(imageURL: String, name: String, group: String, id: Int) {
        guard
            let url = URL(string: imageURL),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else {
            return
        }
        
        profileImageView.image = image
        nameLabel.text = name
        groupLabel.text = group
        
        if id == UserDefaultsManager.id {
            hostIcon.isHidden = false
            participantButton.isHidden = true
        } else {
            hostIcon.isHidden = true
            participantButton.isHidden = false
        }
    }
}
