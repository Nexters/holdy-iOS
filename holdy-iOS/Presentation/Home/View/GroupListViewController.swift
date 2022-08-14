//
//  GroupListViewController.swift
//  holdy-iOS
//
//  Created by Ellen on 2022/08/14.
//

import UIKit
import RxSwift
import RxDataSources

enum ItemSection {
    case groupInfo
}

final class GroupListViewController: UIViewController, UIScrollViewDelegate {
    
    private let viewModel = GroupListViewModel()
    private let bag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: configureFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
       return collectionView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(GroupListCell.self, forCellWithReuseIdentifier: GroupListCell.id)
        view = collectionView
        bind()
        
        viewModel.input.onViewDidLoad.accept(())
    }
    
    private func bind() {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        viewModel.output.sectionsRelay
            .bind(to: collectionView.rx.items(dataSource: createDatasource()))
            .disposed(by: bag)
        
    }
}

extension GroupListViewController {
    
    private func configureFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize.height = 300
        return layout
    }
    
    private func createDatasource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<ItemSection, GroupInfo>> {
        return .init { datasource, collectionView, indexPath, items in
            let section = datasource.sectionModels[indexPath.section].identity
            
            switch section {
            case .groupInfo:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupListCell.id,
                                                                    for: indexPath) as? GroupListCell else {
                    return UICollectionViewCell()
                }
                
                cell.setUpLabel(items)
                return cell
            }
        }
    }
}
