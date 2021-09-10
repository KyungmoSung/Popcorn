//
//  HomeViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/19.
//

import Foundation
import RxSwift

class HomeViewModel: ViewModelType {
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
        let selectedSection: Observable<HomeSection>
    }
    
    private let networkService: TmdbService
    private let coordinator: HomeCoordinator
    
    init(networkService: TmdbService = TmdbAPI(), coordinator: HomeCoordinator) {
        self.networkService = networkService
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let refreshTrigger = Observable.merge(input.ready, input.localizeChanged)
        
        let updateTrigger = Observable.combineLatest(refreshTrigger,
                                                     input.contentsTypeSelection
                                                        .startWith(ContentsType.movies)
                                                        .distinctUntilChanged())

        // Update - 현재 타입에 해당하는 Charts API 호출
        let sectionItems = updateTrigger
            .flatMap { _, contentsType -> Observable<[HomeSectionItem]> in
                switch contentsType {
                case .movies:
                    return Observable.combineLatest(
                        MovieChart.allCases.map { chart in
                            self.networkService.movies(chart: chart, page: 1)
                                .map { $0.map { PosterItemViewModel(with: $0, heroID: (chart.title ?? "") + "\($0.id)") }}
                                .map { HomeSectionItem(section: .movie(chart), items: $0) }
                        }
                    )
                case .tvShows:
                    return Observable.combineLatest(
                        TVShowChart.allCases.map { chart in
                            self.networkService.tvShows(chart: chart, page: 1)
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
            .do(onNext: { content, heroID in
                self.coordinator.showDetail(content: content, heroID: heroID)
            })
            .map { $0.0 }
        
        // 헤더 선택 - 차트 리스트 화면 이동
        let selectedSection = input.headerSelection
            .withLatestFrom(sectionItems) { section, result in
                return result[section].section
            }
            .do(onNext: coordinator.showChart(section:))
        
        return Output(sectionItems: sectionItems, selectedContent: selectedContent, selectedSection: selectedSection)
    }
}
