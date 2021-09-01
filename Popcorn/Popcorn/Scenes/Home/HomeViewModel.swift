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
    typealias HomeSectionItem = _SectionItem<HomeSection, PosterItemViewModel>
    
    struct Input {
        let ready: Driver<Void>
        let localizeChanged: Driver<Void>
        let contentsTypeSelection: Driver<ContentsType>
        let headerSelection: Driver<Int>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let contents: Driver<[HomeSectionItem]>
        let selectedContentID: Driver<Int>
        let selectedSection: Driver<HomeSection>
    }
    
    private let networkService: TmdbService
    private let coordinator: HomeCoordinator
    
    init(networkService: TmdbService = TmdbAPI(), coordinator: HomeCoordinator) {
        self.networkService = networkService
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let refreshTrigger = Observable.merge(input.ready.asObservable(),
                                             input.localizeChanged.asObservable())
        
        let updateTrigger = Observable.combineLatest(refreshTrigger,
                                               input.contentsTypeSelection.asObservable()
                                                .startWith(ContentsType.movies)
                                                .distinctUntilChanged())

        let result = updateTrigger
            .flatMap { _, contentsType -> Observable<[HomeSectionItem]> in
                switch contentsType {
                case .movies:
                    return Observable.combineLatest(
                        MovieChart.allCases.map { chart in
                            self.networkService.movies(chart: chart, page: 1)
                                .map { $0.map { PosterItemViewModel(with: $0, heroID: chart.title + "\($0.id)") }}
                                .map { HomeSectionItem(section: .movie(chart), items: $0) }
                        }
                    )
                case .tvShows:
                    return Observable.combineLatest(
                        TVShowChart.allCases.map { chart in
                            self.networkService.tvShows(chart: chart, page: 1)
                                .map { $0.map { PosterItemViewModel(with: $0, heroID: chart.title + "\($0.id)") }}
                                .map { HomeSectionItem(section: .tvShow(chart), items: $0) }
                        }
                    )
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        let selectedContentsID = input.selection
            .withLatestFrom(result) { indexPath, result in
                return result[indexPath.section].items[indexPath.row].id
            }
            .do(onNext: coordinator.showDetail(id:))
        
        let selectedSection = input.headerSelection
            .withLatestFrom(result) { section, result in
                return result[section].section
            }
            .do(onNext: coordinator.showChart(section:))
        
        return Output(contents: result, selectedContentID: selectedContentsID, selectedSection: selectedSection)
    }
}
