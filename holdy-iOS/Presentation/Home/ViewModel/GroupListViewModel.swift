//
//  GroupListViewModel.swift
//  holdy-iOS
//
//  Created by Ellen on 2022/08/14.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

protocol GroupListInputInterface {
    var onViewDidLoad: PublishRelay<Void> { get }
}

protocol GroupListOutputInterFace {
    var sectionsRelay: Observable<[SectionModel<ItemSection, GroupInfo>]> { get }
}

protocol GroupListInterfaceable {
    var input: GroupListInputInterface { get }
    var output: GroupListOutputInterFace { get }
}

final class GroupListViewModel: GroupListInterfaceable, GroupListInputInterface, GroupListOutputInterFace {
    
    private let baseRouter = BaseRouter()
    private let bag = DisposeBag()
    
    // MARK: - GroupListInterfaceable Properties
    var input: GroupListInputInterface { return self }
    var output: GroupListOutputInterFace { return self }
    
    // MARK: - InputProperties
    var onViewDidLoad: PublishRelay<Void> = .init()
    
    // MARK: - OutputProperties
    var sectionsRelay: Observable<[SectionModel<ItemSection, GroupInfo>]> {
        return sectionSubject.asObservable()
    }
    
    // MARK: - Private OutputProperties
    private let sectionSubject: PublishSubject<[SectionModel<ItemSection, GroupInfo>]> = .init()
    
    init() {
        bind()
    }
    
    private func bind() {
        input.onViewDidLoad
            .flatMap { [weak self] _ -> Observable<[SectionModel<ItemSection, GroupInfo>]> in
                guard let self = self else { return Observable.empty() }
                return self.receiveGroupList().asObservable()
            }.bind(to: sectionSubject)
            .disposed(by: bag)
    }
    
    private func receiveGroupList() -> Observable<[SectionModel<ItemSection, GroupInfo>]> {
        self.baseRouter.requestGroupList(api: HoldyAPI.GetGroupList(), decodingType: [GroupInfo].self)
            .map { groupInfos -> [SectionModel<ItemSection, GroupInfo>] in
                return [.init(model: .groupInfo, items: groupInfos)]
            }
            .asObservable()
    }
}
