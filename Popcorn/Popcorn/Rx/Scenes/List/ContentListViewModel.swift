//
//  ContentListViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/10.
//

import Foundation
import RxSwift

class ContentListViewModel: ViewModel {
    typealias ListSectionItem = _SectionItem<ListSection, PosterItemViewModel>
    
    struct Input {
        let ready: Observable<Void>
        let scrollToBottom: Observable<Void>
        let selection: Observable<IndexPath>
    }
    
    struct Output {
        let loading: Observable<Bool>
        let title: Observable<String>
        let sectionItems: Observable<[ListSectionItem]>
        let selectedContent: Observable<_Content>
    }

    private var page = 1
    private let id: Int?
    private var contents: [_Content]
    private let sourceSection: _SectionType
    private let coordinator: ContentListCoordinator
    
    init(with contents: [_Content], id: Int? = nil, sourceSection: _SectionType, networkService: TmdbService = TmdbAPI(), coordinator: ContentListCoordinator) {
        self.id = id
        self.contents = contents
        self.sourceSection = sourceSection
        self.coordinator = coordinator
        
        super.init(networkService: networkService)
    }

    func transform(input: Input) -> Output {
        let sectionItems = BehaviorSubject<[ListSectionItem]>(value: [])
        
        input.ready
            .flatMap { [weak self] _ -> Observable<[PosterItemViewModel]> in
                guard let self = self else { return Observable.just([]) }
                
                self.page = 1
                return self.request()
            }
            .subscribe(onNext: { viewModels in
                let sectionItem = ListSectionItem(section: .contents, items: viewModels)
                sectionItems.onNext([sectionItem])
            })
            .disposed(by: disposeBag)
        
        input.scrollToBottom.withLatestFrom(activityIndicator)
            .flatMap { [weak self] loading -> Observable<[PosterItemViewModel]> in
                guard let self = self else { return Observable.just([]) }
                
                if loading {
                    return Observable.empty()
                } else {
                    self.page += 1
                    return self.request()
                }
            }
            .subscribe(onNext: { viewModels in
                if var sectionItem = try? sectionItems.value().first(where: { $0.section == .contents }) {
                    sectionItem.items += viewModels
                    sectionItems.onNext([sectionItem])
                }
            })
            .disposed(by: disposeBag)
        
        let title = Observable.just(sourceSection.title).compactMap{ $0 }
        
        // 셀 선택 - 디테일 화면 이동
        let selectedContent = input.selection
            .withLatestFrom(sectionItems) { indexPath, result in
                let viewModel = result[indexPath.section].items[indexPath.row]
                return (viewModel.content, viewModel.posterHeroId)
            }
            .do(onNext: coordinator.showDetail)
            .map { $0.0 }
        
        
        return Output(loading: activityIndicator.asObservable(), title: title, sectionItems: sectionItems, selectedContent: selectedContent)
    }
    
    func request() -> Observable<[PosterItemViewModel]> {
        var results: Observable<[_Content]> = Observable.just([])
        
        if page == 1 {
            results = Observable.just(contents)
        } else {
            switch (sourceSection, id) {
            case (let homeSection as HomeSection, _):
                switch homeSection {
                case let .movie(chart):
                    results = networkService.movies(chart: chart, page: page).mapToContents()
                case let .tvShow(chart):
                    results = networkService.tvShows(chart: chart, page: page).mapToContents()
                }
            case (let detailSection as DetailSection, .some(let id)):
                switch detailSection {
                case .movie(.recommendation):
                    results = networkService.movieRecommendations(id: id, page: page).mapToContents()
                default:
                    break
                }
            default:
                break
            }
        }
        
        return results
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .map { contents -> [PosterItemViewModel] in
                contents.forEach{ print("#id : \($0.id)") }
                let viewModels = contents.map { PosterItemViewModel(with: $0, heroID: "\($0.id)") }
                return viewModels
            }
    }
}
