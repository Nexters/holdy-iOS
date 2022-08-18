//
//  Created by 양호준 on 2022/08/04.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class GeneratingGroupViewController: UIViewController {
    // MARK: - PickerType
    enum Picker: Int {
        case date
        case startTime
        case endTime
        
        var componentCount: Int {
            switch self {
            case .date:
                return 3
            case .startTime:
                return 2
            case .endTime:
                return 2
            }
        }
    }
    
    // MARK: - Properties
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_close"), for: .normal)
    }
    
    private let contentContainer = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 30
    }
    
    private let dateContainer = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private let dateTitleLabel = UILabel().then {
        $0.text = "날짜 *"
        $0.font = UIFont.pretendardWithDefaultSize(family: .semiBold)
        
        let titleText = $0.text as? NSString
        let range = titleText?.range(of: "*")
        let attributes = NSMutableAttributedString(string: $0.text ?? "")
        attributes.addAttributes(
            [
                NSAttributedString.Key.font: UIFont.pretendard(family: .regular, size: 12),
                NSAttributedString.Key.foregroundColor: UIColor.strongBlue
            ],
            range: range ?? NSRange()
        )
        $0.attributedText = attributes
    }
    
    private let dateTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "모임날짜",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray5,
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.addLeftPadding()
        $0.clearButtonMode = .always
    }
    
    private let datePicker = UIDatePicker()
    
    private let timePickerContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private let startTimePicker = UIPickerView().then {
        $0.tag = PickerTag.startTime
    }
    
    private let endTimePicker = UIPickerView().then {
        $0.tag = PickerTag.endTime
    }
    
    private let startTimeTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "모임 시작 시간",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray5,
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.maskedCorners = [.layerMinXMaxYCorner]
        $0.addLeftPadding()
        $0.clearButtonMode = .always
        $0.font = UIFont.pretendardWithDefaultSize(family: .regular)
    }
    
    private let endTimeTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "모임 종료 시간",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray5,
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner]
        $0.addLeftPadding()
        $0.clearButtonMode = .always
        $0.font = UIFont.pretendardWithDefaultSize(family: .regular)
    }
    
    private let locationContainer = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private let locationTitleLabel = UILabel().then {
        $0.text = "장소 *"
        $0.font = UIFont.pretendardWithDefaultSize(family: .semiBold)
        
        let titleText = $0.text as? NSString
        let range = titleText?.range(of: "*")
        let attributes = NSMutableAttributedString(string: $0.text ?? "")
        attributes.addAttributes(
            [
                NSAttributedString.Key.font: UIFont.pretendard(family: .regular, size: 12),
                NSAttributedString.Key.foregroundColor: UIColor.strongBlue
            ],
            range: range ?? NSRange()
        )
        $0.attributedText = attributes
    }
    
    private let locationNameTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "장소 이름",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray5,
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        $0.font = UIFont.pretendardWithDefaultSize(family: .regular)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.addLeftPadding()
        $0.clearButtonMode = .always
        $0.returnKeyType = .done
    }
    
    private let locationDetailTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "상세주소",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray5,
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        $0.font = UIFont.pretendardWithDefaultSize(family: .regular)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.addLeftPadding()
        $0.clearButtonMode = .always
        $0.returnKeyType = .done
    }
    
    private let locationLinkContainer = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private let locationLinkTitleLabel = UILabel().then {
        $0.text = "장소 링크"
        $0.font = UIFont.pretendardWithDefaultSize(family: .semiBold)
    }
    
    private let locationLinkTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "네이버 지도, 카카오 지도 링크를 입력하세요",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray5,
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        $0.font = UIFont.pretendardWithDefaultSize(family: .regular)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 5
        $0.addLeftPadding()
        $0.clearButtonMode = .always
        $0.returnKeyType = .done
        $0.clipsToBounds = true
    }
    
    private let linkWarningLabel = UILabel().then {
        $0.text = "링크가 잘못되지 않았는지 확인해주세요"
        $0.textColor = .customRed
        $0.font = .pretendard(family: .regular, size: 12)
        $0.isHidden = true
    }
    
    private let generatingGroupButton = UIButton().then {
        $0.backgroundColor = .weakBlue
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.setTitle("모임 만들기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray3, for: .highlighted)
        $0.titleLabel?.font = UIFont.pretendardWithDefaultSize(family: .medium)
        $0.isUserInteractionEnabled = true
    }
    
    private let disposeBag = DisposeBag()
    private var viewModel: GeneratingGroupViewModel!
    private var coordinator: GeneratingGroupCoordinator!
    
    private let hourList: [String] = [
        "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12",
        "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"
    ]
    private let minuteList: [String] = ["00", "15", "30", "45"]
    
    private var selectedHour = "00"
    private var selectedMinute = "00"
    
    // MARK: - Initializers
    convenience init(viewModel: GeneratingGroupViewModel, coordinator: GeneratingGroupCoordinator) {
        self.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        setAttributes()
        configureDatePicker()
        configureTimePicker()
        configureTextField()
    }

    deinit {
        coordinator.end()
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        bind()
    }
    
    // MARK: - Methods
    private func setAttributes() {
        view.backgroundColor = .white
    }
    
    private func configureDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace, target: nil, action: nil
        )
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: nil, action: #selector(cancelButtonTapped)
        )
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTappedAtDatePicker)
        )
        
        toolbar.setItems([flexibleSpace, cancelButton, doneButton], animated: true)
        
        datePicker.tag = PickerTag.date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    private func configureTimePicker() {
        let startToolbar = UIToolbar()
        let endToolbar = UIToolbar()
        startToolbar.sizeToFit()
        endToolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace, target: nil, action: nil
        )
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: nil, action: #selector(cancelButtonTapped)
        )
        let startDoneButton = UIBarButtonItem(
            barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTappedAtStartTimePicker)
        )
        let endDoneButton = UIBarButtonItem(
            barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTappedAtEndTimePicker)
        )
        
        startToolbar.setItems([flexibleSpace, cancelButton, startDoneButton], animated: true)
        endToolbar.setItems([flexibleSpace, cancelButton, endDoneButton], animated: true)
        
        startTimePicker.delegate = self
        startTimePicker.dataSource = self
        
        endTimePicker.delegate = self
        endTimePicker.dataSource = self
        
        startTimeTextField.tintColor = .clear
        startTimeTextField.inputView = startTimePicker
        startTimeTextField.inputAccessoryView = startToolbar
        
        endTimeTextField.tintColor = .clear
        endTimeTextField.inputView = endTimePicker
        endTimeTextField.inputAccessoryView = endToolbar
    }
    
    private func configureTextField() {
        locationNameTextField.delegate = self
        locationDetailTextField.delegate = self
        locationLinkTextField.delegate = self
    }
    
    @objc
    private func doneButtonTappedAtDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd (E)"
        
        dateTextField.attributedText = NSAttributedString(
            string: dateFormatter.string(from: datePicker.date),
            attributes: [
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        view.endEditing(true)
    }
    
    @objc
    private func doneButtonTappedAtStartTimePicker() {
        startTimeTextField.text = "\(selectedHour):\(selectedMinute)"
        
        view.endEditing(true)
    }
    
    @objc
    private func doneButtonTappedAtEndTimePicker() {
        endTimeTextField.text = "\(selectedHour):\(selectedMinute)"
        
        view.endEditing(true)
    }
    
    @objc
    private func cancelButtonTapped() {
        view.endEditing(true)
    }
    
    private func render() {
        view.addSubview(closeButton)
        view.addSubview(contentContainer)
        view.addSubview(generatingGroupButton)
        view.addSubview(linkWarningLabel)
        
        contentContainer.addArrangedSubview(dateContainer)
        contentContainer.addArrangedSubview(locationContainer)
        contentContainer.addArrangedSubview(locationLinkContainer)
        
        dateContainer.addArrangedSubview(dateTitleLabel)
        dateContainer.addArrangedSubview(dateTextField)
        dateContainer.addArrangedSubview(timePickerContainer)
        
        timePickerContainer.addArrangedSubview(startTimeTextField)
        timePickerContainer.addArrangedSubview(endTimeTextField)
        
        locationContainer.addArrangedSubview(locationTitleLabel)
        locationContainer.addArrangedSubview(locationNameTextField)
        locationContainer.addArrangedSubview(locationDetailTextField)
        
        locationLinkContainer.addArrangedSubview(locationLinkTitleLabel)
        locationLinkContainer.addArrangedSubview(locationLinkTextField)
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        contentContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        dateTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        startTimeTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }

        locationNameTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        locationDetailTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        locationLinkTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        linkWarningLabel.snp.makeConstraints {
            $0.top.equalTo(locationLinkTextField.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(17)
        }
        
        generatingGroupButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(48)
        }
    }
    
    private func bind() {
        let textInputObservable = configureTextInputObserable()
        let input = GeneratingGroupViewModel.Input(generatingGroupButtonDidTap: textInputObservable)
        let output = viewModel.transform(input)
        
        configureGeneratingGroupButton(output: output.generatesGroup)
        configureCloseButton()
        configureEditingTextField()
        configureEndEditingTextField()
    }

    private func configureTextInputObserable() -> Observable<(
        startDate: String,
        endDate: String,
        summary: String,
        address: String,
        mapLink: String
    )> {
        return generatingGroupButton.rx.tap.asObservable()
            .withUnretained(self)
            .map { view, _ -> (startDate: String, endDate: String, summary: String, address: String, mapLink: String) in
                guard
                    let date = view.dateTextField.text,
                    let startTime = view.startTimeTextField.text,
                    let endTime = view.endTimeTextField.text,
                    let summary = view.locationNameTextField.text,
                    let address = view.locationDetailTextField.text,
                    let mapLink = view.locationLinkTextField.text
                else {
                    return ("", "", "", "", "")
                }

                let formattedDate = date.prefix(10)
                let startDate = "\(formattedDate)T\(startTime):00"
                let endDate = "\(formattedDate)T\(endTime):00"

                return (startDate, endDate, summary, address, mapLink)
            }
    }
    
    private func configureGeneratingGroupButton(output: Driver<GeneratingGroupResponse>) {
        output
            .drive(onNext: { [weak self] response in
                guard let self = self else { return }
                
                if response.data == nil {
                    self.showGeneratingGroupFailAlert()
                } else {
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showGeneratingGroupFailAlert() {
        let alert = UIAlertController(
            title: "그룹 생성을 샐패했습니다.",
            message: """
            모든 정보를 입력해주세요
            (마감일이 시작일 이후여야 합니다)
            """,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func configureCloseButton() {
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureEditingTextField() {
        dateTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.dateTextField.layer.borderColor = UIColor.strongBlue.cgColor
            })
            .disposed(by: disposeBag)
        
        startTimeTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.startTimeTextField.layer.borderColor = UIColor.strongBlue.cgColor
            })
            .disposed(by: disposeBag)
        
        endTimeTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.endTimeTextField.layer.borderColor = UIColor.strongBlue.cgColor
            })
            .disposed(by: disposeBag)
        
        locationNameTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.locationNameTextField.layer.borderColor = UIColor.strongBlue.cgColor
            })
            .disposed(by: disposeBag)
        
        locationDetailTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.locationDetailTextField.layer.borderColor = UIColor.strongBlue.cgColor
            })
            .disposed(by: disposeBag)
        
        locationLinkTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                guard let input = viewController.locationLinkTextField.text else {
                    viewController.locationLinkTextField.layer.borderColor = UIColor.strongBlue.cgColor
                    
                    return
                }
                let isNaverMap = input.contains("naver.me") || input.contains("map.naver.com")
                let isKakapmap = input.contains("kko.to") || input.contains("map.kakao.com")
                
                guard isKakapmap || isNaverMap else {
                    viewController.linkWarningLabel.isHidden = false
                    viewController.locationLinkTextField.layer.borderColor = UIColor.strongBlue.cgColor
                    
                    return
                }
                
                viewController.linkWarningLabel.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
    private func configureEndEditingTextField() {
        dateTextField.rx.controlEvent(.editingDidEnd).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.dateTextField.layer.borderColor = UIColor.gray5.cgColor
                viewController.judgeEssentialTextField()
            })
            .disposed(by: disposeBag)
        
        startTimeTextField.rx.controlEvent(.editingDidEnd).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.startTimeTextField.layer.borderColor = UIColor.gray5.cgColor
                viewController.judgeEssentialTextField()
            })
            .disposed(by: disposeBag)
        
        endTimeTextField.rx.controlEvent(.editingDidEnd).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.endTimeTextField.layer.borderColor = UIColor.gray5.cgColor
                viewController.judgeEssentialTextField()
            })
            .disposed(by: disposeBag)
        
        locationNameTextField.rx.controlEvent(.editingDidEnd).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.locationNameTextField.layer.borderColor = UIColor.gray5.cgColor
                viewController.judgeEssentialTextField()
            })
            .disposed(by: disposeBag)
        
        locationDetailTextField.rx.controlEvent(.editingDidEnd).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.locationDetailTextField.layer.borderColor = UIColor.gray5.cgColor
                viewController.judgeEssentialTextField()
            })
            .disposed(by: disposeBag)
        
        locationLinkTextField.rx.controlEvent(.editingDidEnd).asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.locationLinkTextField.layer.borderColor = UIColor.gray5.cgColor
            })
            .disposed(by: disposeBag)
    }
    
    private func judgeEssentialTextField() {
        guard
            let dateText = dateTextField.text,
            let startTimeText = startTimeTextField.text,
            let endTimeText = endTimeTextField.text,
            let locationNameText = locationNameTextField.text,
            let locationDetailText = locationDetailTextField.text
        else {
            return
        }
        
        if dateText.count > 0 &&
            startTimeText.count > 0 &&
            endTimeText.count > 0 &&
            locationNameText.count > 0 &&
            locationDetailText.count > 0 {
            generatingGroupButton.backgroundColor = .strongBlue
            generatingGroupButton.isUserInteractionEnabled = true
        }
    }
}

extension GeneratingGroupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let componentCount = Picker(rawValue: pickerView.tag)?.componentCount else {
            return 0
        }
        
        return componentCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hourList.count
        case 1:
            return minuteList.count
        default:
            return 0
        }
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        switch component {
        case 0:
            return "\(hourList[row]) : "
        case 1:
            return "\(minuteList[row])"
        default:
            return ""
        }
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        switch component {
        case 0:
            selectedHour = hourList[row]
        case 1:
            selectedMinute = minuteList[row]
        default:
            break
        }
    }
}

extension GeneratingGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.attributedText = NSAttributedString(
            string: textField.text ?? "",
            attributes: [
                NSAttributedString.Key.font: UIFont.pretendardWithDefaultSize(family: .regular)
            ]
        )
        return true
    }
}

extension GeneratingGroupViewController {
    enum PickerTag {
        static let date = 0
        static let startTime = 1
        static let endTime = 2
    }
}
