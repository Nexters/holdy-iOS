//
//  Created by 양호준 on 2022/08/18.
//

import UIKit

import KakaoSDKShare
import KakaoSDKTemplate
import RxCocoa
import RxSwift
import SafariServices

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
    
    // MARK: - 카카오 공유에 전달하기 위한 프로퍼티
    private var sharePlace = ""
    private var shareStartDate = ""
    private var shareID = ""
    
    // MARK: - Initializers
    convenience init(
        viewModel: GroupDetailViewModel,
        participantsInfo: Observable<[ParticipantsDescribing]>
    ) {
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
            guestGuideContainer,
            titleLabel,
            participantsCollectionview,
            inviteButton,
            inviteButtonExplanation
        ])
        
        guestGuideContainer.adds([
            guestGuideIcon,
            guestGuideLabel
        ])
        
        guestGuideContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.width.equalTo(327)
            $0.height.equalTo(48)
        }
        
        guestGuideIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }
        
        guestGuideLabel.snp.makeConstraints {
            $0.centerY.equalTo(guestGuideIcon.snp.centerY)
            $0.leading.equalTo(guestGuideIcon.snp.trailing).offset(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(guestGuideContainer.snp.bottom).offset(28)
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
    
    private func configureGuestPage() {
        guard UserDefaultsManager.id != GroupDetailViewModel.hostID else {
            return
        }
        
        let text = "모임이 끝나면 홀드를 확인할 수 있어요"
        let highlightedText = "홀드를 확인할 수"
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
        guestGuideLabel.attributedText = mutableAttributedString
        
        inviteButtonExplanation.isHidden = true
        inviteButton.isHidden = true
    }
    
    // MARK: - Binding Methods
    private func bind() {
        configureParticipantsCollectionViewContent()
        configureInviteButton()
    }
    
    private func configureParticipantsCollectionViewContent() {
        participantsInfo
            .bind(to: participantsCollectionview.rx.items(
                cellIdentifier: String(describing: ParticipantCell.self),
                cellType: ParticipantCell.self
            )) { [weak self] row, item, cell in
                guard let self = self else { return }
                
                cell.configureContent(
                    imageURL: item.profileImageUrl,
                    name: item.nickname,
                    group: item.group,
                    id: item.id,
                    row: row
                )
                cell.delegate = self
                
                self.configureGuestPage()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureInviteButton() {
        inviteButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                let templateID: Int64 = 81345
                 
                if ShareApi.isKakaoTalkSharingAvailable() {
                    ShareApi.shared.shareCustom(
                        templateId: templateID,
                        templateArgs: [
                            "title": viewController.sharePlace,
                            "content": viewController.shareStartDate,
                            "moim_id": viewController.shareID
                        ]
                    ) { shareResult, error in
                        if let error = error {
                            #if DEBUG
                            print(error)
                            #endif
                        } else {
                            if let shareResult = shareResult {
                                UIApplication.shared.open(shareResult.url)
                            }
                        }
                    }
                } else {
                    if let url = ShareApi.shared.makeCustomUrl(
                        templateId: templateID,
                        templateArgs: ["title": "제목입니다.", "description": "설명입니다."]
                    ) {
                        let safariViewController = SFSafariViewController(url: url)
                        safariViewController.modalTransitionStyle = .crossDissolve
                        safariViewController.modalPresentationStyle = .overCurrentContext
                        self.present(safariViewController, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension BottomSheetContentViewController {
    func configureShareTemplateArgs(id: String, place: String, date: String) {
        self.shareID = id
        self.sharePlace = place
        self.shareStartDate = date
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

extension BottomSheetContentViewController: ParticipantCellDelegate {
    func showErrorAlert(message: String?) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)

        present(alert, animated: true)
    }
}
