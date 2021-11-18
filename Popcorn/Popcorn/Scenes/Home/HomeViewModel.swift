//
//  HomeViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/19.
//

import Foundation
import RxSwift

class HomeViewModel: ViewModel {
    typealias HomeSectionItem = SectionItem<HomeSection, RowViewModel>
    
    struct Input {
        let ready: Observable<Void>
        let localizeChanged: Observable<Void>
        let headerSelection: Observable<Int>
        let selection: Observable<IndexPath>
    }
    
    struct Output {
        let loading: Observable<Bool>
        let sectionItems: Observable<[HomeSectionItem]>
        let selectedContent: Observable<Content>
        let selectedSection: Observable<HomeSection>
    }
    
    private let coordinator: HomeCoordinator
    let contentsType: ContentsType
    
    init(contentsType: ContentsType, networkService: TmdbService = TmdbAPI(), coordinator: HomeCoordinator) {
        self.contentsType = contentsType
        self.coordinator = coordinator
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
        let refreshTrigger = Observable.merge(input.ready, input.localizeChanged)
            .map{ self.contentsType }

        // Update - 현재 타입에 해당하는 Charts API 호출
        let sectionItems = refreshTrigger
            .flatMap { [weak self] contentsType -> Observable<[HomeSectionItem]> in
                guard let self = self else { return Observable.just([]) }
                
                switch contentsType {
                case .movies:
                    return Observable.combineLatest(
                        MovieChart.allCases.map { chart in
                            self.networkService.movies(chart: chart, page: 1)
                                .trackActivity(self.activityIndicator)
                                .trackError(self.errorTracker)
                                .mapToResults()
                                .map {
                                    if chart == .nowPlaying {
                                        return $0.map { BackdropItemViewModel(with: $0, heroID: (chart.title ?? "") + "\($0.id)") }
                                    } else {
                                        return $0.map { PosterItemViewModel(with: $0, heroID: (chart.title ?? "") + "\($0.id)") }
                                    }
                                }
                                .map { HomeSectionItem(section: .movie(chart), items: $0) }
                        }
                    )
                case .tvShows:
                    return Observable.combineLatest(
                        TVShowChart.allCases.map { chart in
                            self.networkService.tvShows(chart: chart, page: 1)
                                .trackActivity(self.activityIndicator)
                                .trackError(self.errorTracker)
                                .mapToResults()
                                .map {
                                    if chart == .airingToday {
                                        return $0.map { BackdropItemViewModel(with: $0, heroID: (chart.title ?? "") + "\($0.id)") }
                                    } else {
                                        return $0.map { PosterItemViewModel(with: $0, heroID: (chart.title ?? "") + "\($0.id)") }
                                    }
                                }
                                .map { HomeSectionItem(section: .tvShow(chart), items: $0) }
                        }
                    )
                }
            }
        
        // 셀 선택 - 디테일 화면 이동
        let selectedContent = input.selection
            .withLatestFrom(sectionItems) { indexPath, result in
                let viewModel = result[indexPath.section].items[indexPath.row]
                switch viewModel {
                case let viewModel as PosterItemViewModel:
                    return (viewModel.content, viewModel.posterHeroId)
                case let viewModel as BackdropItemViewModel:
                    return (viewModel.content, viewModel.backdropHeroId)
                default:
                    return nil
                }
            }
            .compactMap { $0 }
            .do(onNext: coordinator.showDetail)
            .map { $0.0 }
        
        // 헤더 선택 - 차트 리스트 화면 이동
        let selectedSection = input.headerSelection
            .withLatestFrom(sectionItems) { section, result in
                let section = result[section].section
                return section
            }
            .do(onNext: coordinator.showChartList)
        
        let loading = activityIndicator.asObservable()
                
        return Output(loading: loading, sectionItems: sectionItems, selectedContent: selectedContent, selectedSection: selectedSection)
    }
}
