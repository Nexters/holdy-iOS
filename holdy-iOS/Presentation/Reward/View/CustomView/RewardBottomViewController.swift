//
//  Created by 양호준 on 2022/10/01.
//

import UIKit

import RxSwift

final class RewardBottomViewController: UIViewController {
    private let backgroundView = UIImageView().then {
        $0.contentMode = .topLeft
        $0.image = UIImage(named: "hold_background")
    }
    
    private let countLabel = UILabel().then {
        $0.text = "0개"
        $0.textColor = .gray9
        $0.font = .pretendard(family: .semiBold, size: 24)
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "홀드를 모았어요"
        $0.textColor = .gray5
        $0.font = .pretendard(family: .regular, size: 16)
        $0.textAlignment = .center
    }
    
    private let rewardListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = true
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    // MARK: - Properties
    private var holdRewards: [UIImage?]!
    private var parentView: RewardListViewController!
    private let disposeBag = DisposeBag()
    private let selectedIndexPath = PublishSubject<IndexPath>()
    
    convenience init(holdRewards: [UIImage?], parent: RewardListViewController!) {
        self.init(nibName: nil, bundle: nil)
        
        self.holdRewards = holdRewards
        self.parentView = parent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        configureCollectionView()
        configureCountLabel()
    }
    
    // MARK: - Methods
    private func render() {
        view.backgroundColor = .white
        
        view.adds([
            backgroundView,
            countLabel,
            descriptionLabel,
            rewardListView
        ])
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        rewardListView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        rewardListView.dataSource = self
        rewardListView.delegate = self
        rewardListView.register(cellClass: RewardHoldCell.self)
    }
    
    private func configureCountLabel() {
        countLabel.text = "\(holdRewards.count)개"
    }
}

extension RewardBottomViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionCount = holdRewards.count / 7 + 1
        
        return sectionCount * 2 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section % 2 != 0 {
            return 3
        } else {
            return 4
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: RewardHoldCell.self),
            for: indexPath
        ) as? RewardHoldCell else {
            return UICollectionViewCell()
        }
        
        let index = indexPath.section * 4 - indexPath.section / 2 + indexPath.item
        
        guard let cellImage = holdRewards[safe: index] else {
            return cell
        }
        
        cell.configureContent(image: cellImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentView.selectedIndexPath.onNext(indexPath)
    }
}

extension RewardBottomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: 80,
            height: 80
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let inset = (collectionView.bounds.width - 270) / 2
        
        if section % 2 == 0 {
            return UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        } else {
            return UIEdgeInsets(top: .zero, left: inset, bottom: .zero, right: inset)
        }
    }
}
