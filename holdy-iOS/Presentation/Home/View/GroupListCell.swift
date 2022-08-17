//
//  Created by Ellen on 2022/08/15.
//  Modified by 양호준 on 2022/08/16.
//

import UIKit

import SnapKit
import Then

final class GroupListCell: UICollectionViewCell {
    enum Status {
        case attendance
        case host
        case complete
        case absent
        
        var icon: UIImage? {
            switch self {
            case .attendance:
                return UIImage(named: "icon_check")
            case .host:
                return UIImage(named: "icon_host")
            case .complete:
                return UIImage(named: "icon_participantCheck")
            case .absent:
                return UIImage(named: "icon_absent")
            }
        }
    }
    
    // MARK: - UI Components
    private let dottedLine = UIImageView().then {
        $0.image = UIImage(named: "dotted_line")
        $0.contentMode = .scaleAspectFill
    }
    
    private let statusIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLocationLabel = UILabel().then {
        $0.textColor = .gray9
        $0.font = .pretendard(family: .semiBold, size: 16)
    }
    
    private let locationIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_location")
    }
    
    private let locationLabel = UILabel().then {
        $0.textColor = .gray7
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    private let dateIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_calendar")
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .gray7
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    private(set) var id: Int = .zero
    
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
        statusIcon.image = nil
        titleLocationLabel.text = nil
        locationLabel.text = nil
    }
    
    // MARK: - Methods
    private func render() {
        adds([
            dottedLine,
            statusIcon,
            titleLocationLabel,
            locationIcon,
            locationLabel,
            dateIcon,
            dateLabel
        ])
        
        dottedLine.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.width.equalTo(1)
        }
        
        statusIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(42)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(20)
        }
        
        titleLocationLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(statusIcon.snp.trailing).offset(20)
            $0.width.equalTo(180)
            $0.height.equalTo(22)
        }
        
        locationIcon.snp.makeConstraints {
            $0.top.equalTo(titleLocationLabel.snp.bottom).offset(20)
            $0.leading.equalTo(titleLocationLabel.snp.leading)
            $0.width.height.equalTo(16)
        }
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationIcon.snp.centerY)
            $0.leading.equalTo(locationIcon.snp.trailing)
            $0.width.equalTo(253)
            $0.height.equalTo(20)
        }

        dateIcon.snp.makeConstraints {
            $0.top.equalTo(locationIcon.snp.bottom).offset(10)
            $0.leading.equalTo(locationIcon.snp.leading)
            $0.width.height.equalTo(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateIcon.snp.centerY)
            $0.leading.equalTo(dateIcon.snp.trailing)
            $0.width.equalTo(253)
            $0.height.equalTo(20)
        }
    }
    
    private func generateDate(_ text: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date: Date = formatter.date(from: text) else { return Date() }
        return date
    }
    
    private func attributeDateLabel(_ text: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: generateDate(text))
    }
    
    private func generateStatusIcon(_ model: GroupInfo) {
        if model.isEnd {
            statusIcon.image = Status.complete.icon
        } else {
            if model.loginUser.isHost {
                statusIcon.image = Status.host.icon
            } else if model.loginUser.wantToAttend {
                statusIcon.image = Status.attendance.icon
            } else {
                statusIcon.image = Status.absent.icon
            }
        }
    }
    
    func configureContent(by model: GroupInfo) {
        generateStatusIcon(model)
        titleLocationLabel.text = model.place.summary
        locationLabel.text = model.place.address
        dateLabel.text = attributeDateLabel(model.startDate)
        id = model.id
    }
}
