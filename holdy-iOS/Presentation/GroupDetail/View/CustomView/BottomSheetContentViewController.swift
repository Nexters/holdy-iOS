//
//  Created by 양호준 on 2022/08/18.
//

import UIKit

import RxCocoa
import RxSwift

final class BottomSheetContentViewController: UIViewController {
    // MARK: - UI Components
    private let guestGuideContainer = UIView().then {
        $0.backgroundColor = .gray0
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let guestGuideIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_info")
    }

    private let guestGuideLabel = UILabel().then {
        let text = "모임 시간 동안 출석 체크할 수 있어요"
        let highlightedText = "출석 체크"
        let allRange = (text as NSString).range(of: text)
        let highlightedRange = (text as NSString).range(of: highlightedText)
        let mutableAttributedString = NSMutableAttributedString(string: text)
        mutableAttributedString.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.pretendard(family: .regular, size: 14),
            range: allRange
        )
        mutableAttributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.gray9,
            range: allRange
        )
        mutableAttributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.customRed,
            range: highlightedRange
        )
        $0.attributedText = mutableAttributedString
    }

    private let titleLabel = UILabel().then {
        $0.text = "모임 참여자"
        $0.textColor = .gray9
        $0.font = .pretendard(family: .semiBold, size: 18)
    }

    private let inviteButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_invite"), for: .normal)
    }
    
    private let inviteButtonExplanation = UIImageView().then {
        $0.image = UIImage(named: "info_invitation_link")
        $0.contentMode = .scaleAspectFit
    }

    private let attendanceButton = UIButton().then {
        $0.setTitle("갈게요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretendard(family: .medium, size: 16)

        $0.backgroundColor = .veryStrongBlue

        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let participantsCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = true
        
        return collectionView
    }()
    
    // MARK: - Properties
    private var viewModel: GroupDetailViewModel!
    private var participantsInfo: Observable<[ParticipantsDescribing]>!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    convenience init(viewModel: GroupDetailViewModel, participantsInfo: Observable<[ParticipantsDescribing]>) {
        self.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.participantsInfo = participantsInfo
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        configureCollectionView()
        bind()
    }
    
    // MARK: - Methods
    private func render() {
        view.backgroundColor = .white
        
        view.adds([
            titleLabel,
            participantsCollectionview,
            inviteButton,
            inviteButtonExplanation
        ])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(100)
            $0.height.equalTo(25)
        }
        
        participantsCollectionview.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        inviteButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(24)
        }
        
        inviteButtonExplanation.snp.makeConstraints {
            $0.centerY.equalTo(inviteButton.snp.centerY)
            $0.trailing.equalTo(inviteButton.snp.leading).offset(-4)
            $0.width.equalTo(173)
            $0.height.equalTo(27)
        }
    }
    
    private func configureCollectionView() {
        participantsCollectionview.delegate = self
        participantsCollectionview.register(cellClass: ParticipantCell.self)
    }
    
    private func configureInviteButtonExplanation() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.inviteButtonExplanation.alpha = .zero
            },
            completion: nil
        )
    }
    
    // MARK: - Binding Methods
    private func bind() {
        configureParticipantsCollectionViewContent()
    }
    
    private func configureParticipantsCollectionViewContent() {
        participantsInfo
            .bind(to: participantsCollectionview.rx.items(
                cellIdentifier: String(describing: ParticipantCell.self),
                cellType: ParticipantCell.self
            )) { [weak self]  _, item, cell in
                guard let self = self else { return }
                
                cell.configureContent(
                    imageURL: item.profileImageUrl,
                    name: item.nickname,
                    group: item.group,
                    isHost: self.viewModel.isHost
                )
            }
            .disposed(by: disposeBag)
    }
}

extension BottomSheetContentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: participantsCollectionview.frame.width,
            height: 72
        )
    }
}
