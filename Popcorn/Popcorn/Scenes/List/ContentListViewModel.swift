//
//  ContentListViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/10.
//

import Foundation
import RxSwift

class ContentListViewModel: ViewModelType {
    typealias ListSectionItem = _SectionItem<ListSection, PosterItemViewModel>
    
    struct Input {
        let ready: Observable<Void>
    }
    
    struct Output {
        let title: Observable<String>
        let sectionItems: Observable<[ListSectionItem]>
    }
    
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
        var page = 1
        let sectionItems = input.ready
            .flatMap { [self] _ -> Observable<[_Content]> in
                if page == 1 {
                    return Observable.just(self.contents)
                } else {
                    switch (self.sourceSection, self.id) {
                    case (let homeSection as HomeSection, _):
                        switch homeSection {
                        case let .movie(chart):
                            return self.networkService.movies(chart: chart, page: page).map { $0 as [_Content] }
                        case let .tvShow(chart):
                            return self.networkService.tvShows(chart: chart, page: page).map { $0 as [_Content] }
                        }
                    case (let detailSection as DetailSection, .some(let id)):
                        switch detailSection {
                        case .movie(.recommendation):
                            return self.networkService.movieRecommendations(id: id, page: page).map { $0 as [_Content] }
                        default:
                            return Observable.just([])
                        }
                    default:
                        return Observable.just([])
                    }
                }
            }
            .map { contents -> [ListSectionItem] in
                let viewModels = contents.map { PosterItemViewModel(with: $0, heroID: "\($0.id)") }
                return [ListSectionItem(section: .contents, items: viewModels)]
            }
            .do(onNext: { _ in
                page += 1
            })
        
        let title = Observable.just(sourceSection.title).compactMap{ $0 }

        return Output(title: title, sectionItems: sectionItems)
    }
}
