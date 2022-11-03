//
//  Created by 양호준 on 2022/08/18.
//

import UIKit

import RxSwift
import SnapKit
import Then

protocol ParticipantCellDelegate: AnyObject {
    func showErrorAlert(message: String?)
}

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
        
        $0.isHidden = true
    }
    
    private let participantButton = UIButton().then {
        $0.setTitle("왔어요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .regular, size: 12)
        $0.backgroundColor = .strongBlue
        $0.layer.borderWidth = .zero
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray1
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = ParticipantCellViewModel()
    
    weak var delegate: ParticipantCellDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
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
            $0.horizontalEdges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func bind() {
        let input = ParticipantCellViewModel.Input(
            participantButtonDidTap: participantButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input)
        
        output.response
            .withUnretained(self)
            .subscribe(onNext: { cell, response in
                if response.message != nil {
                    cell.delegate?.showErrorAlert(message: response.message)
                }
                
                if response.isAttended {
                    cell.participantButton.setTitle("왔어요", for: .normal)
                    cell.participantButton.backgroundColor = .strongBlue
                    cell.participantButton.layer.borderWidth = .zero
                } else {
                    cell.participantButton.setTitle("안왔어요", for: .normal)
                    cell.participantButton.setTitleColor(.gray6, for: .normal)
                    cell.participantButton.backgroundColor = .white
                    cell.participantButton.layer.borderWidth = 1
                    cell.participantButton.layer.borderColor = UIColor.gray3.cgColor
                }
            })
            .disposed(by: disposeBag)
    }
    
    func configureContent(
        imageURL: String,
        name: String,
        group: String,
        id: Int,
        row: Int,
        attended: Bool = false
    ) {
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
            participantButton.isHidden = true
        } else {
            participantButton.isHidden = false
        }
        
        if row == .zero {
            hostIcon.isHidden = false
            participantButton.isHidden = true
        }
        
        if attended {
            participantButton.setTitle("안왔어요", for: .normal)
            participantButton.setTitleColor(.gray6, for: .normal)
            participantButton.backgroundColor = .white
            participantButton.layer.borderWidth = 1
            participantButton.layer.borderColor = UIColor.gray3.cgColor

        } else {
            participantButton.setTitle("왔어요", for: .normal)
            participantButton.backgroundColor = .strongBlue
            participantButton.layer.borderWidth = .zero
        }
    }
    
    func hideParticipantButton() {
        participantButton.isHidden = true
    }
}
