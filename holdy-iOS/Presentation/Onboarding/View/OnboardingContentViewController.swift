//
//  OnboardingContentViewController.swift
//  holdy-iOS
//
//  Created by 양호준 on 2022/08/13.
//

import UIKit

import SnapKit
import Then

final class OnboardingContentViewController: UIViewController {
    // MARK: - UI Components
    private let characterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .pretendard(family: .medium, size: 24)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: - Initializers
    convenience init(image: UIImage?, description: String) {
        self.init(nibName: nil, bundle: nil)
        
        self.characterImageView.image = image
        self.descriptionLabel.text = description
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    // MARK: - Methods
    private func render() {
        view.adds([characterImageView, descriptionLabel])
        
        characterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(characterImageView.snp.bottom).offset(35)
        }
    }
}
