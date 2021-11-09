//
//  RecommendViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/01.
//

import Foundation
import RxSwift

class RecommendViewModel: ViewModel {
    typealias RecommendSectionItem = _SectionItem<ListSection, PosterItemViewModel>

    struct Input {
        let ready: Observable<Void>
    }
    
    struct Output {
        let loading: Observable<Bool>
        let needSignIn: Observable<Bool>
        let sectionItems: Observable<[RecommendSectionItem]>
    }
    
    private let coordinator: RecommendCoordinator
    
    init(networkService: TmdbService, coordinator: RecommendCoordinator) {
        self.coordinator = coordinator
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
        let isSignIn = input.ready
            .map{ AuthManager.shared.isSignIn() }
        
        // 미로그인시 로그인으로 이동
        let needSignIn = isSignIn
            .do(onNext: { [weak self] isSignIn in
                guard let self = self else { return }
                
                if !isSignIn {
                    self.coordinator.showSignIn()
                }
            })

        let sectionItems = AuthManager.shared.profileResultSubject
            .flatMap { [weak self] _ -> Observable<[_Movie]> in
                guard let self = self, let accountID = AuthManager.shared.auth?.accountID else {
                    return Observable.just([])
                }
                    
                return self.networkService.accountMovieRecommendations(accountID: accountID , sortBy: .createdAt(.asc))
            }
            .map{ $0.map { PosterItemViewModel(with: $0, heroID: "\($0.id)") }}
            .map { [RecommendSectionItem(section: .contents, items: $0)] }
        
        
        let loading = activityIndicator.asObservable()
        
        return Output(loading: loading, needSignIn: needSignIn, sectionItems: sectionItems)
    }
}
