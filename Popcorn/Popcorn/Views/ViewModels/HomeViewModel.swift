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
    typealias HomeSection = _SectionItem<_Section.Home, PosterViewModel>
    
    struct Input {
        let ready: Driver<Void>
        let changeContentsType: Driver<ContentsType>
        let selectedIndex: Driver<IndexPath>
        let selectedSection: Driver<Int>
    }
    
    struct Output {
        let contents: Driver<[HomeSection]>
        let selectedContentID: Driver<Int>
        let selectedSection: Driver<_Section.Home>
    }
    
    private let networkService: TmdbService
    
    init(networkService: TmdbService = TmdbAPI()) {
        self.networkService = networkService
    }
    
    func transform(input: Input) -> Output {
        let trigger = Observable.combineLatest(input.ready
                                                .asObservable(),
                                               input.changeContentsType
                                                .distinctUntilChanged()
                                                .asObservable())

        let result = trigger
            .flatMap { _, contentsType -> Observable<[HomeSection]> in
                switch contentsType {
                case .movies:
                    return Observable.combineLatest(
                        MovieChart.allCases.map { chart in
                            self.networkService.movies(chart: chart, page: 1)
                                .map { $0.map { PosterViewModel(with: $0) } }
                                .map { HomeSection(section: .movie(chart), items: $0) }
                        }
                    )
                case .tvShows:
                    return Observable.combineLatest(
                        TVShowChart.allCases.map { chart in
                            self.networkService.tvShows(chart: chart, page: 1)
                                .map { $0.map { PosterViewModel(with: $0) } }
                                .map { HomeSection(section: .tvShow(chart), items: $0) }
                        }
                    )
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        let selectedContentsID = input.selectedIndex
            .withLatestFrom(result) { indexPath, result in
                return result[indexPath.section].items[indexPath.row].id
            }
        
        let selectedSection = input.selectedSection
            .withLatestFrom(result) { section, result in
                return result[section].section
            }
        
        return Output(contents: result, selectedContentID: selectedContentsID, selectedSection: selectedSection)
    }
}
