//
//  HomeViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/19.
//

import Foundation
import RxSwift

class HomeViewModel: ViewModel {
    typealias HomeSectionItem = _SectionItem<HomeSection, PosterItemViewModel>
    
    struct Input {
        let ready: Observable<Void>
        let localizeChanged: Observable<Void>
        let contentsTypeSelection: Observable<ContentsType>
        let headerSelection: Observable<Int>
        let selection: Observable<IndexPath>
    }
    
    struct Output {
        let sectionItems: Observable<[HomeSectionItem]>
        let selectedContent: Observable<_Content>
        let selectedSection: Observable<([_Content], HomeSection)>
    }
    
    private let coordinator: HomeCoordinator
    
    init(networkService: TmdbService = TmdbAPI(), coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
        let refreshTrigger = Observable.merge(input.ready, input.localizeChanged)
        
        let updateTrigger = Observable.combineLatest(refreshTrigger,
                                                     input.contentsTypeSelection
                                                        .startWith(ContentsType.movies)
                                                        .distinctUntilChanged())

        // Update - 현재 타입에 해당하는 Charts API 호출
        let sectionItems = updateTrigger
            .flatMap { [weak self] _, contentsType -> Observable<[HomeSectionItem]> in
                guard let self = self else { return Observable.just([]) }
                
                switch contentsType {
                case .movies:
                    return Observable.combineLatest(
                        MovieChart.allCases.map { chart in
                            self.networkService.movies(chart: chart, page: 1)
                                .trackActivity(self.activityIndicator)
                                .trackError(self.errorTracker)
                                .map { $0.map { PosterItemViewModel(with: $0, heroID: (chart.title ?? "") + "\($0.id)") }}
                                .map { HomeSectionItem(section: .movie(chart), items: $0) }
                        }
                    )
                case .tvShows:
                    return Observable.combineLatest(
                        TVShowChart.allCases.map { chart in
                            self.networkService.tvShows(chart: chart, page: 1)
                                .trackActivity(self.activityIndicator)
                                .trackError(self.errorTracker)
                                .map { $0.map { PosterItemViewModel(with: $0, heroID: (chart.title ?? "") + "\($0.id)") }}
                                .map { HomeSectionItem(section: .tvShow(chart), items: $0) }
                        }
                    )
                }
            }
        
        // 셀 선택 - 디테일 화면 이동
        let selectedContent = input.selection
            .withLatestFrom(sectionItems) { indexPath, result in
                return (result[indexPath.section].items[indexPath.row].content, result[indexPath.section].items[indexPath.row].posterHeroId)
            }
            .do(onNext: coordinator.showDetail)
            .map { $0.0 }
        
        // 헤더 선택 - 차트 리스트 화면 이동
        let selectedSection = input.headerSelection
            .withLatestFrom(sectionItems) { section, result in
                return (result[section].items.map { $0.content }, result[section].section)
            }
            .do(onNext: coordinator.showChartList)
        
        return Output(sectionItems: sectionItems, selectedContent: selectedContent, selectedSection: selectedSection)
    }
}
