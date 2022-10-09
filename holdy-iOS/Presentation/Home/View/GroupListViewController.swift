//
//  Created by Ellen on 2022/08/14.
//  Modified by 양호준 on 2022/08/16.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class GroupListViewController: UIViewController {
    // MARK: - UI Components
    private lazy var navigationView = GroupListNavigationView(cooridnator: coordinator)
    
    private let hideCompeltedGroupButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_check"), for: .normal)
        $0.setTitle("끝난 모임 숨기기", for: .normal)
        $0.titleLabel?.font = .pretendard(family: .regular, size: 12)
        $0.setTitleColor(.gray6, for: .normal)
    }
    
    private let emptyImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "holdy_error")
        $0.isHidden = true
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "아직 초대받은 모임이 없어요\n직접 만들어 볼까요?"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .gray5
        $0.font = .pretendard(family: .regular, size: 18)
        $0.isHidden = true
    }
    
    private let listCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    private let generatingGroupButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_add_selected"), for: .normal)
    }
    
    // MARK: - Properties
    private var viewModel: GroupListViewModel!
    private var coordinator: HomeCoordinator!
    private var isFirstLoad = true
    private let disposeBag = DisposeBag()
    private let loadDataWithViewWillAppear = PublishSubject<Bool>()
    
    convenience init(viewModel: GroupListViewModel, coordinator: HomeCoordinator) {
        self.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.view.backgroundColor = .white
        
        bind()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh),
            name: NSNotification.Name("EnterForeground"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name("EnterForeground"),
            object: nil
        )
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        render()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDataWithViewWillAppear.onNext(true)
        
        if !isFirstLoad {
            listCollectionview.reloadData()
            listCollectionview.scrollToItem(at: IndexPath(item: .zero, section: .zero), at: .top, animated: true)
        }
        
        isFirstLoad = false
    }
    
    // MARK: - Methods
    @objc
    private func refresh() {
        listCollectionview.reloadData()
    }
    
    private func configureCollectionView() {
        listCollectionview.register(cellClass: GroupListCell.self)
        listCollectionview.delegate = self
    }
    
    private func render() {
        view.adds([
            navigationView,
            emptyImageView,
            emptyLabel,
            hideCompeltedGroupButton,
            listCollectionview,
            generatingGroupButton
        ])
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(90)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom).offset(123)
            $0.width.equalTo(209)
            $0.height.equalTo(74)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImageView.snp.bottom).offset(30)
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        hideCompeltedGroupButton.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(101)
            $0.height.equalTo(20)
        }
        
        listCollectionview.snp.makeConstraints {
            $0.top.equalTo(hideCompeltedGroupButton.snp.bottom).offset(30)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        generatingGroupButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(64)
        }
    }
    
    // MARK: - Binding Methods
    private func bind() {
        let input = GroupListViewModel.Input(
            loadDataWithViewWillAppear: loadDataWithViewWillAppear.asObservable()
        )
        let output = viewModel.transform(input)
        
        configureCollectionViewContent(output.groupInfos)
        configureGenratingGroupButton()
        configureHideCompleteButton()
    }
    
    private func configureCollectionViewContent(_ output: Observable<[GroupInfo]>) {
        output
            .map { [weak self] groupInfos -> [GroupInfo] in
                guard let self = self else { return [] }
                
                if groupInfos.isEmpty {
                    self.emptyImageView.isHidden = false
                    self.emptyLabel.isHidden = false
                    self.hideCompeltedGroupButton.isHidden = true
                    self.listCollectionview.isHidden = true
                }
                
                return groupInfos
            }
            .bind(to: listCollectionview.rx.items(
                cellIdentifier: String(describing: GroupListCell.self),
                cellType: GroupListCell.self
            )) { row, item, cell in
                cell.configureContent(
                    by: item,
                    isFirst: row == 0
                )
            }
            .disposed(by: disposeBag)
    }
    
    private func configureGenratingGroupButton() {
        generatingGroupButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (viewController, _) in
                viewController.coordinator.startGeneratingGruopCoordinator()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureHideCompleteButton() {
        hideCompeltedGroupButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                if viewController.viewModel.isFiltered {
                    viewController.hideCompeltedGroupButton.setImage(
                        UIImage(named: "icon_check"),
                        for: .normal
                    )
                } else {
                    viewController.hideCompeltedGroupButton.setImage(
                        UIImage(named: "icon_check_selected"),
                        for: .normal
                    )
                }
                
                viewController.loadDataWithViewWillAppear.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}

extension GroupListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GroupListCell else {
            return
        }
        
        coordinator.startGroupDetailCoordinator(with: cell.id)
    }
}

extension GroupListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: listCollectionview.frame.width,
            height: 130
        )
    }
}
