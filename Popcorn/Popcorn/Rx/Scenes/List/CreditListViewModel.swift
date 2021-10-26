//
//  CreditListViewModel.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/10/26.
//

import Foundation
import RxSwift

class CreditListViewModel: ViewModel {
    typealias ListSectionItem = _SectionItem<ListSection, CreditItemViewModel>
    
    struct Input {
        let ready: Observable<Void>
    }
    
    struct Output {
        let loading: Observable<Bool>
        let title: Observable<String>
        let sectionItems: Observable<[ListSectionItem]>
    }

    private var credits: [Person]
    private let sourceSection: _SectionType
    private let coordinator: ContentListCoordinator
    
    init(with credits: [Person], sourceSection: _SectionType, networkService: TmdbService = TmdbAPI(), coordinator: ContentListCoordinator) {
        self.credits = credits
        self.sourceSection = sourceSection
        self.coordinator = coordinator
        
        super.init(networkService: networkService)
    }

    func transform(input: Input) -> Output {
        let sectionItems = BehaviorSubject<[ListSectionItem]>(value: [])
        
        input.ready
            .flatMap { [weak self] _ -> Observable<[CreditItemViewModel]> in
                guard let self = self else { return Observable.just([]) }
                
                return Observable.just(self.credits)
                    .trackActivity(self.activityIndicator)
                    .trackError(self.errorTracker)
                    .map { credits -> [CreditItemViewModel] in
                        let viewModels = credits.map { CreditItemViewModel(with: $0) }
                        return viewModels
                    }
            }
            .subscribe(onNext: { viewModels in
                let sectionItem = ListSectionItem(section: .contents, items: viewModels)
                sectionItems.onNext([sectionItem])
            })
            .disposed(by: disposeBag)
                
        let title = Observable.just(sourceSection.title).compactMap{ $0 }
        
        return Output(loading: activityIndicator.asObservable(), title: title, sectionItems: sectionItems)
    }
}
