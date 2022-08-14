//
//  GroupListCell.swift
//  holdy-iOS
//
//  Created by Ellen on 2022/08/15.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class GroupListCell: UICollectionViewCell {
    static let id = "\(GroupListCell.self)"
    
    private let statusIcon = UIImageView().then {
        $0.image = UIImage(named: "icon_check")
    }
    
    private let titleLocationLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .pretendard(family: .semiBold, size: 16)
    }
    
    private let locationIcon = UIImageView().then {
        $0.image = UIImage(named: "icon_location")
    }
    
    private let locationLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    private let calendarIcon = UIImageView().then {
        $0.image = UIImage(named: "icon_calendar")
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .pretendard(family: .regular, size: 14)
    }
    
    private func setUp() {
        
        addSubview(statusIcon)
        statusIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusIcon.widthAnchor.constraint(equalToConstant: 20),
            statusIcon.heightAnchor.constraint(equalToConstant: 20),
            statusIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            statusIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        addSubview(titleLocationLabel)
        titleLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLocationLabel.heightAnchor.constraint(equalToConstant: 22.4),
            titleLocationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLocationLabel.leadingAnchor.constraint(equalTo: statusIcon.trailingAnchor, constant: 20),
        ])
        
        addSubview(locationIcon)
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationIcon.widthAnchor.constraint(equalToConstant: 20),
            locationIcon.heightAnchor.constraint(equalToConstant: 20),
            locationIcon.leadingAnchor.constraint(equalTo: statusIcon.trailingAnchor, constant: 20),
            locationIcon.topAnchor.constraint(equalTo: titleLocationLabel.bottomAnchor, constant: 20)
        ])
        
        addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        addSubview(calendarIcon)
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarIcon.widthAnchor.constraint(equalToConstant: 20),
            calendarIcon.heightAnchor.constraint(equalToConstant: 20),
            calendarIcon.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: 8),
            calendarIcon.leadingAnchor.constraint(equalTo: locationIcon.leadingAnchor),
            calendarIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            
        ])
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.centerYAnchor.constraint(equalTo: calendarIcon.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor)
        ])
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
        if model.loginUser.isHost {
            statusIcon.image = UIImage(named: "icon_host")
        } else if !model.loginUser.wantToAttend {
            statusIcon.image = UIImage(named: "icon_check")
        } else {
            statusIcon.image = UIImage(named: "icon_check_selected")
        }
    }
    
    func setUpLabel(_ model: GroupInfo) {
        generateStatusIcon(model)
        titleLocationLabel.text = model.place.summary
        locationLabel.text = model.place.address
        dateLabel.text = attributeDateLabel(model.startDate)
    }
}
