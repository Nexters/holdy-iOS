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
        
        $0.isHidden = true
    }
    
    // MARK: - Properties
    private var onboardingPages = [OnboardingContentViewController]()
    
    // MARK: - Initializers
    convenience init(pages: [OnboardingContentViewController]) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        self.onboardingPages = pages
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePages()
        render()
    }
    
    // MARK: - Methods
    private func configurePages() {
        delegate = self
        dataSource = self
        
        guard let firstPage = onboardingPages.first else { return }
        setViewControllers([firstPage], direction: .forward, animated: true)
        pageControl.numberOfPages = onboardingPages.count
    }
    
    private func render() {
        view.backgroundColor = .strongBlue
        
        view.adds([pageControl, startButton])
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(56)
        }
        
        startButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
            $0.width.equalTo(335)
            $0.height.equalTo(48)
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    // MARK: - DataSource
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
    
    // MARK: - Delegate
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        let onboardingPages = onboardingPages as [UIViewController]
        
        guard
            let visibleViewController = pageViewController.viewControllers?.first,
            let currentIndex = onboardingPages.firstIndex(of: visibleViewController)
        else { return }
        
        setButtonByIndex(currentIndex)
        pageControl.currentPage = currentIndex
    }
    
    private func setButtonByIndex(_ currentIndex: Int) {
        if currentIndex != onboardingPages.count - 1 {
            startButton.isHidden = true
            pageControl.isHidden = false
        } else {
            startButton.isHidden = false
            pageControl.isHidden = true
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        let onboardingPages = onboardingPages as [UIViewController]
        
        guard
            let visibleViewController = pageViewController.viewControllers?.first,
            let currentIndex = onboardingPages.firstIndex(of: visibleViewController)
        else { return }
        
        setButtonByIndex(currentIndex)
    }
}
