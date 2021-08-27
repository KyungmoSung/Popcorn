//
//  HomeViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/19.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class HomeViewModel: ViewModelType {
    typealias HomeSection = _Section<_SectionType.Home, PosterViewModel>

    struct Input {
        let ready: Driver<Void>
//        let changeContentsType: Driver<ContentsType>
        let selectedIndex: Driver<IndexPath>
        let selectedSection: Driver<Int>
    }
    
    struct Output {
        let contents: Driver<[HomeSection]>
        let selectedContentID: Driver<Int>
        let selectedSection: Driver<_SectionType.Home>
    }
    
    private let networkService: TmdbService
    
    init(networkService: TmdbService = TmdbAPI()) {
        self.networkService = networkService
    }
    
    func transform(input: Input) -> Output {
        let result = input.ready
            .asObservable()
            .flatMapLatest {
                Observable.combineLatest(
                    self.networkService.nowPlayingMovies(page: 1),
                    self.networkService.popularMovies(page: 1)
                )
            }
            .map { nowPlaying, popular -> [HomeSection] in
                let nowPlayingViewModels = nowPlaying.map { PosterViewModel(with: $0) }
                let popularViewModels = popular.map { PosterViewModel(with: $0) }
                
                let sections: [HomeSection] = [
                    HomeSection(sectionType: .movie(.nowPlaying),
                                items: nowPlayingViewModels),
                    HomeSection(sectionType: .movie(.popular),
                                items: popularViewModels)
                ]
                return sections
            }
            .asDriver(onErrorJustReturn: [])

        let selectedContentsID = input.selectedIndex
            .withLatestFrom(result) { indexPath, result in
                return result[indexPath.section].items[indexPath.row].id
            }
        
        let selectedSection = input.selectedSection
            .withLatestFrom(result) { section, result in
                return result[section].sectionType
            }
        
        return Output(contents: result, selectedContentID: selectedContentsID, selectedSection: selectedSection)
    }
}
