//
//  Created by 양호준 on 2022/08/18.
//

import UIKit

import FloatingPanel
import RxCocoa
import RxSwift
import SnapKit
import Then

final class GroupDetailViewController: UIViewController {
    enum SheetMode {
        case common
        case full

        var ratio: CGFloat {
            switch self {
            case .common:
                return 0.5
            case .full:
                return 0
            }
        }
    }

    // MARK: - UI Components
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_close_highlighted"), for: .normal)
        $0.setImage(UIImage(named: "icon_close"), for: .highlighted)
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .pretendard(family: .bold, size: 32)
    }

    private let locationIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_location")
    }

    private let locationLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .pretendard(family: .regular, size: 14)
    }

    private let dateIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_calendar")
    }

    private let dateLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .pretendard(family: .regular, size: 14)
    }

    private let openMapAppButton = UIButton().then {
        $0.setTitle("지도 앱 열기 →", for: .normal)
        $0.setTitleColor(
            UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.5), // 투명도가 적용된 흰색
            for: .normal
        )
        $0.titleLabel?.font = .pretendard(family: .regular, size: 12)
        $0.contentHorizontalAlignment = .leading
    }
    
    private let bottomSheetViewController = FloatingPanelController()
    private var contentViewController: BottomSheetContentViewController!

    // MARK: - Properties
    private var viewModel: GroupDetailViewModel!
    private var coordinator: GroupDetailCoordinator!

    private let disposeBag = DisposeBag()

    // MARK: - Initializers
    convenience init(viewModel: GroupDetailViewModel, coordinator: GroupDetailCoordinator) {
        self.init(nibName: nil, bundle: nil)

        self.viewModel = viewModel
        self.coordinator = coordinator

        bind()
    }
    
    deinit {
        coordinator.end()
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        render()
    }

    private func render() {
        view.backgroundColor = .strongBlue

        view.adds([
            closeButton,
            titleLabel,
            locationIcon,
            locationLabel,
            dateIcon,
            dateLabel,
            openMapAppButton,
            bottomSheetViewController.view
        ])
        
        bottomSheetViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(view.bounds.width - 20)
            $0.height.equalTo(45)
        }

        locationIcon.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(16)
        }

        locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationIcon.snp.centerY)
            $0.leading.equalTo(locationIcon.snp.trailing).offset(8)
            $0.width.equalTo(260)
            $0.height.equalTo(20)
        }

        dateIcon.snp.makeConstraints {
            $0.top.equalTo(locationIcon.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(16)
        }

        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateIcon.snp.centerY)
            $0.leading.equalTo(dateIcon.snp.trailing).offset(8)
            $0.width.equalTo(260)
            $0.height.equalTo(20)
        }

        openMapAppButton.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(44)
            $0.width.equalTo(253)
            $0.height.equalTo(20)
        }
    }
    
    private func configureBottomSheet(participantsInfo: Observable<[ParticipantsDescribing]>) {
        contentViewController = BottomSheetContentViewController(
            viewModel: viewModel,
            participantsInfo: participantsInfo
        )
        let layout = BottomSheetLayout()
        
        bottomSheetViewController.set(contentViewController: contentViewController)
        bottomSheetViewController.changeSheetStyle()
        bottomSheetViewController.addPanel(toParent: self)
        bottomSheetViewController.layout = layout
    }

    // MARK: - Binding Methods
    private func bind() {
        let input = GroupDetailViewModel.Input(viewDidLoad: rx.viewDidLoad)
        let output = viewModel.transform(input)
        
        configureCloseButton()
        configureContent(with: output.groupInfo)
        configureBottomSheet(participantsInfo: output.participantsInfo)
    }

    private func configureContent(with groupInfo: Driver<GroupInfo>) {
        groupInfo
            .drive(onNext: { [weak self] groupInfo in
                guard let self = self else { return }

                self.titleLabel.text = groupInfo.place.summary
                self.locationLabel.text = groupInfo.place.address
                let startDate = self.attributeStartDateLabel(groupInfo.startDate)
                let endDate = self.attributeEndDateLabel(groupInfo.endDate)
                self.dateLabel.text = "\(startDate) ~ \(endDate)"

            })
            .disposed(by: disposeBag)
    }
    
    private func configureCloseButton() {
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (viewController, _) in
                viewController.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func attributeStartDateLabel(_ text: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 a hh시"
        formatter.locale = Locale(identifier: "ko_KR")

        return formatter.string(from: generateDate(text))
    }

    private func attributeEndDateLabel(_ text: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh시"
        formatter.locale = Locale(identifier: "ko_KR")

        return formatter.string(from: generateDate(text))
    }

    private func generateDate(_ text: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date: Date = formatter.date(from: text) else { return Date() }
        return date
    }
}

extension FloatingPanelController {
    func changeSheetStyle() {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 30
        surfaceView.appearance = appearance
    }
}

final class BottomSheetLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 15, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.6, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
