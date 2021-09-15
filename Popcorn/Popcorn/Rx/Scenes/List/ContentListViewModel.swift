//
//  ContentListViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/10.
//

import Foundation
import RxSwift
import NSObject_Rx

class ContentListViewModel: ViewModelType {
    typealias ListSectionItem = _SectionItem<ListSection, PosterItemViewModel>
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let ready: Observable<Void>
        let scrollToBottom: Observable<Void>
    }
    
    struct Output {
        let loading: Observable<Bool>
        let title: Observable<String>
        let sectionItems: Observable<[ListSectionItem]>
    }

    let activityIndicator = ActivityIndicator()
    private var page = 1
    private let id: Int?
    private var contents: [_Content]
    private let sourceSection: _SectionType
    private let networkService: TmdbService
    private let coordinator: ContentListCoordinator
    
    init(with contents: [_Content], id: Int? = nil, sourceSection: _SectionType, networkService: TmdbService = TmdbAPI(), coordinator: ContentListCoordinator) {
        self.id = id
        self.contents = contents
        self.sourceSection = sourceSection
        self.networkService = networkService
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {
        let sectionItems = BehaviorSubject<[ListSectionItem]>(value: [])
        
        activityIndicator.asObservable()
            .debug()
            .subscribe()
            .disposed(by: disposeBag)
        
        input.ready
            .flatMap { _ -> Observable<[PosterItemViewModel]> in
                self.page = 1
                return self.request()
            }
            .subscribe(onNext: { viewModels in
                let sectionItem = ListSectionItem(section: .contents, items: viewModels)
                sectionItems.onNext([sectionItem])
            })
            .disposed(by: disposeBag)
        
        input.scrollToBottom.withLatestFrom(activityIndicator)
            .flatMap { loading -> Observable<[PosterItemViewModel]> in
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
        
        return Output(loading: activityIndicator.asObservable(), title: title, sectionItems: sectionItems)
    }
    
    func request() -> Observable<[PosterItemViewModel]> {
        var contents: Observable<[_Content]> = Observable.just([])
        
        if page == 1 {
            contents = Observable.just(self.contents)
        } else {
            switch (sourceSection, id) {
            case (let homeSection as HomeSection, _):
                switch homeSection {
                case let .movie(chart):
                    contents = networkService.movies(chart: chart, page: page)
                        .map { $0 as [_Content] }
                case let .tvShow(chart):
                    contents = networkService.tvShows(chart: chart, page: page)
                        .map { $0 as [_Content] }
                }
            case (let detailSection as DetailSection, .some(let id)):
                switch detailSection {
                case .movie(.recommendation):
                    contents = networkService.movieRecommendations(id: id, page: page)
                        .map { $0 as [_Content] }
                default:
                    break
                }
            default:
                break
            }
        }
        
        return contents
            .trackActivity(activityIndicator)
            .map { contents -> [PosterItemViewModel] in
                let viewModels = contents.map { PosterItemViewModel(with: $0, heroID: "\($0.id)") }
                return viewModels
            }
    }
}
