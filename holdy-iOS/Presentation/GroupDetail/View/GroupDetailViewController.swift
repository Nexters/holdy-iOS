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
    // MARK: - UI Components
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_close_highlighted"), for: .normal)
        $0.setImage(UIImage(named: "icon_close"), for: .highlighted)
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .pretendard(family: .bold, size: 32)
    }
    
    private let reportButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_report"), for: .normal)
        $0.isHidden = true
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
    
    private let participantButton = UIButton().then {
        $0.setTitle("갈게요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray5, for: .highlighted)
        $0.backgroundColor = .strongBlue
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.isHidden = true
    }
    
    private let bottomSheetViewController = FloatingPanelController()
    private var contentViewController: BottomSheetContentViewController!

    // MARK: - Properties
    private var viewModel: GroupDetailViewModel!
    private var coordinator: GroupDetailCoordinator!
    private var mapLink: String!

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
    
    override func viewWillAppear(_ animated: Bool) {
        addParticiapantButton() // Floating Panel 관련 view들이 모두 올라오고 추가해야 가장 상단에 위치함.
    }

    private func render() {
        view.backgroundColor = .strongBlue

        view.adds([
            bottomSheetViewController.view,
            closeButton,
            titleLabel,
            reportButton,
            locationIcon,
            locationLabel,
            dateIcon,
            dateLabel,
            openMapAppButton
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
        
        reportButton.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(41)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
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
    
    private func addParticiapantButton() {
        view.add(participantButton)
        
        participantButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
            $0.width.equalTo(335)
            $0.height.equalTo(48)
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
    
    private func configureGuestPage() {
        guard UserDefaultsManager.id != viewModel.hostID else {
            return
        }
        
        reportButton.isHidden = false
        participantButton.isHidden = false
    }

    // MARK: - Binding Methods
    private func bind() {
        let input = GroupDetailViewModel.Input(
            viewDidLoad: rx.viewDidLoad,
            participantButtonDidTap: participantButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input)
        
        configureCloseButton()
        configureOpenMapButton()
        configureReportButton()
        configureContent(with: output.groupInfo)
        configureBottomSheet(participantsInfo: output.participantsInfo)
        configureParticipantButtonAction(with: output.participantButtonResponse)
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
                
                self.contentViewController.configureShareTemplateArgs(
                    id: "\(self.viewModel.id)",
                    place: groupInfo.place.address,
                    date: startDate
                )
                
                self.mapLink = groupInfo.place.mapLink
                
                self.configureGuestPage()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureOpenMapButton() {
        openMapAppButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                if let mapLink = URL(string: viewController.mapLink) {
                    if UIApplication.shared.canOpenURL(mapLink) {
                        UIApplication.shared.open(mapLink, options: [:], completionHandler: nil)
                    } else {
                        let alert = UIAlertController(
                            title: "안내",
                            message: "앱이 설치되어있지 않습니다.",
                            preferredStyle: .alert
                        )
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(okAction)
                        
                        viewController.present(alert, animated: true)
                    }
                }
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
    
    private func configureReportButton() {
        reportButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (viewController, _) in
                let reportViewModel = ReportViewModel(groupID: viewController.viewModel.id)
                let reportViewController = ReportViewController(
                    viewModel: reportViewModel,
                    fromViewController: self
                )
                reportViewController.modalPresentationStyle = .overFullScreen
                
                viewController.present(reportViewController, animated: true)
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
    
    private func configureParticipantButtonAction(
        with response: Observable<GroupDetailViewModel.Output.ParticipantResponse>
    ) {
        response
            .withUnretained(self)
            .subscribe { viewController, response in
                guard let message = response.message else {
                    if response.wantToAttend {
                        viewController.participantButton.setTitle("갈게요", for: .normal)
                        viewController.participantButton.setTitleColor(.white, for: .normal)
                        viewController.participantButton.backgroundColor = .strongBlue
                        viewController.participantButton.layer.borderWidth = 0
                    } else {
                        viewController.participantButton.backgroundColor = .white
                        viewController.participantButton.setTitle("못가요", for: .normal)
                        viewController.participantButton.setTitleColor(.gray6, for: .normal)
                        viewController.participantButton.layer.borderWidth = 1
                        viewController.participantButton.layer.borderColor = UIColor.gray3.cgColor
                    }
                    
                    return
                }
                
                let alert = UIAlertController(
                    title: "에러",
                    message: message,
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(okAction)
                
                viewController.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
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
