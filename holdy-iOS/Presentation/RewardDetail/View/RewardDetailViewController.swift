//
//  Created by 양호준 on 2022/10/02.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class RewardDetailViewController: UIViewController {
    // MARK: - UI Components
    private let backgroundView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "bg_reward_detail")
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_close_highlighted"), for: .normal)
        $0.setImage(UIImage(named: "icon_close"), for: .highlighted)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "모임에 참여하고 받은\n홀드를 자랑해보세요!"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .pretendard(family: .medium, size: 24)
        $0.numberOfLines = 0
    }
    
    private let holdImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let placeLabel = UILabel().then {
        $0.text = "장소"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .pretendard(family: .semiBold, size: 24)
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "날짜"
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.font = .pretendard(family: .regular, size: 16)
    }
    
    private let shareInstaButton = UIButton().then {
        $0.backgroundColor = .veryStrongBlue
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.setTitle("인스타그램에 공유하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray3, for: .highlighted)
        $0.titleLabel?.font = UIFont.pretendardWithDefaultSize(family: .medium)
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: - Properties
    private var viewModel: RewardDetailViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - 인스타 공유 이미지
    private let shareContainerView = UIView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let shareBackground = UIImageView().then {
        let imageName = [
            "bg_insta_1",
            "bg_insta_2",
            "bg_insta_3",
            "bg_insta_4"
        ].randomElement() ?? "bg_insta_1"
        
        $0.image = UIImage(named: imageName)
    }
    
    private let shareHoldImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let sharePlaceLabel = UILabel().then {
        $0.text = "장소"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .pretendard(family: .semiBold, size: 24)
    }
    
    private let shareDateLabel = UILabel().then {
        $0.text = "날짜"
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.font = .pretendard(family: .regular, size: 16)
    }
    
    // MARK: - Initializers
    convenience init(viewModel: RewardDetailViewModel) {
        self.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        
        bind()
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    // MARK: - Methods
    private func render() {
        view.backgroundColor = .black
        
        view.adds([
            backgroundView,
            closeButton,
            titleLabel,
            holdImageView,
            placeLabel,
            dateLabel,
            shareInstaButton,
            shareContainerView
        ])
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(520)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(84)
            $0.centerX.equalToSuperview()
        }
        
        holdImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(148)
        }
        
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(holdImageView.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        shareInstaButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(80)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(50)
        }
        
        shareContainerView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.width.equalTo(335)
            $0.height.equalTo(400)
        }
        
        shareContainerView.adds([
            shareBackground,
            shareHoldImage,
            sharePlaceLabel,
            shareDateLabel
        ])
        
        shareBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shareHoldImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(118)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(120)
        }
        
        sharePlaceLabel.snp.makeConstraints {
            $0.top.equalTo(shareHoldImage.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        shareDateLabel.snp.makeConstraints {
            $0.top.equalTo(sharePlaceLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        let input = RewardDetailViewModel.Input(viewDidLoad: rx.viewDidLoad)
        let output = viewModel.transform(input)
        
        output.info
            .withUnretained(self)
            .subscribe(onNext: { viewController, info in
                viewController.holdImageView.image = info.image
                viewController.placeLabel.text = info.place
                viewController.dateLabel.text = String(describing: info.date)
            })
            .disposed(by: disposeBag)
        
        configureShareInstaButton()
        configureCloseButton()
    }
    
    private func configureShareInstaButton() {
        shareInstaButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                if let storyShareURL = URL(string: "instagram-stories://share") {
                    if UIApplication.shared.canOpenURL(storyShareURL) {
                        viewController.shareHoldImage.image = viewController.holdImageView.image
                        viewController.sharePlaceLabel.text = viewController.placeLabel.text
                        viewController.shareDateLabel.text = viewController.dateLabel.text
                        
                        let renderer = UIGraphicsImageRenderer(
                            size: viewController.shareContainerView.bounds.size
                        )
                        let renderImage = renderer.image { _ in
                            viewController.shareContainerView.drawHierarchy(
                                in: viewController.shareContainerView.bounds,
                                afterScreenUpdates: true
                            )
                        }
                        
                        guard let imageData = renderImage.pngData() else { return }
                        
                        let pasteboardItems : [String:Any] = [
                           "com.instagram.sharedSticker.stickerImage": imageData
                        ]
                        
                        let pasteboardOptions = [
                            UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                        ]
                                        
                        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)

                        UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureCloseButton() {
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
