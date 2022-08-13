//
//  OnboardingPageViewController.swift
//  holdy-iOS
//
//  Created by 양호준 on 2022/08/13.
//

import UIKit

import SnapKit
import Then

final class OnboardingPageViewController: UIPageViewController {
    // MARK: - UI Components
    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .veryStrongBlue
        $0.pageIndicatorTintColor = .gray1
        $0.currentPage = .zero
        $0.backgroundStyle = .minimal
        $0.allowsContinuousInteraction = false
        $0.isUserInteractionEnabled = false
    }
    
    private let startButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(.strongBlue, for: .normal)
        $0.setTitleColor(.gray3, for: .highlighted)
        $0.layer.cornerRadius = 8
        $0.layer.applyShadow(direction: .bottom)
        $0.clipsToBounds = true
    }
    
    private var onboardingPages = [OnboardingContentViewController]()
    
    // MARK: - Initializers
    convenience init(pages: [OnboardingContentViewController]) {
        self.init(nibName: nil, bundle: nil)
        
        self.onboardingPages = pages
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    private func configurePages() {
        guard let firstPage = onboardingPages.first else { return }
        setViewControllers([firstPage], direction: .forward, animated: true)
        pageControl.numberOfPages = onboardingPages.count
    }

}

extension OnboardingPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let onboardingPages = onboardingPages as [UIViewController]
        
        guard
            let currentIndex = onboardingPages.firstIndex(of: viewController) else {
            return nil
        }
        
        return onboardingPages[safe: currentIndex - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let onboardingPages = onboardingPages as [UIViewController]
        
        guard
            let currentIndex = onboardingPages.firstIndex(of: viewController) else {
            return nil
        }
        
        return onboardingPages[safe: currentIndex + 1]
    }
}
