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
        let segmentSelection: Observable<Int>
    }
    
    struct Output {
        let loading: Observable<Bool>
        let title: Observable<String>
        let sectionItems: Observable<[ListSectionItem]>
        let selectedContent: Observable<_Content>
        let segmentedControlVisible: Observable<Bool>
    }

    private var page = 1
    private var contents: [_Content]
    private var sectionType: ListSection
    private let coordinator: ContentListCoordinator
    
    init(with contents: [_Content], sectionType: ListSection, networkService: TmdbService = TmdbAPI(), coordinator: ContentListCoordinator) {
        self.contents = contents
        self.sectionType = sectionType
        self.coordinator = coordinator
        
        super.init(networkService: networkService)
    }

    func transform(input: Input) -> Output {
        let sectionItems = BehaviorSubject<[ListSectionItem]>(value: [
            ListSectionItem(section: sectionType, items: [])
        ])
        
        input.segmentSelection
            .subscribe(onNext: { index in
                self.page = 1
                self.contents = []
                
                if var sectionItem = try? sectionItems.value().first {
                    sectionItem.items = []
                    sectionItems.onNext([sectionItem])
                }
            })
            .disposed(by: disposeBag)
        
        //
        Observable.combineLatest(input.ready,
                                 input.segmentSelection)
            .flatMap { [weak self] _, segmentIndex -> Observable<[PosterItemViewModel]> in
                guard let self = self else { return Observable.just([]) }
                
                self.page = 1
                return self.request(segmentIndex)
            }
            .subscribe(onNext: { viewModels in
                if var sectionItem = try? sectionItems.value().first {
                    sectionItem.items += viewModels
                    sectionItems.onNext([sectionItem])
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.scrollToBottom.withLatestFrom(activityIndicator),
                                 input.segmentSelection)
            .flatMap { [weak self] loading, segmentIndex -> Observable<[PosterItemViewModel]> in
                guard let self = self else { return Observable.just([]) }
                
                if loading {
                    return Observable.empty()
                } else {
                    self.page += 1
                    return self.request(segmentIndex)
                }
            }
            .subscribe(onNext: { viewModels in
                if var sectionItem = try? sectionItems.value().first {
                    sectionItem.items += viewModels.filter{ // API 중복데이터 제외
                        !sectionItem.items.map{ $0.identity }.contains($0.identity)
                    }
                    sectionItems.onNext([sectionItem])
                }
            })
            .disposed(by: disposeBag)
        
        // 셀 선택 - 디테일 화면 이동
        let selectedContent = input.selection
            .withLatestFrom(sectionItems) { indexPath, result in
                let viewModel = result[indexPath.section].items[indexPath.row]
                return (viewModel.content, viewModel.posterHeroId)
            }
            .do(onNext: coordinator.showDetail)
            .map { $0.0 }
        
        let title = Observable.just(sectionType.title).compactMap{ $0 }
        
        let segmentedControlVisible: Observable<Bool>
        if sectionType.segmentTitles.isNilOrEmpty {
            segmentedControlVisible = .just(false)
        } else {
            segmentedControlVisible = .just(true)
        }
        
        return Output(loading: activityIndicator.asObservable(), title: title, sectionItems: sectionItems, selectedContent: selectedContent, segmentedControlVisible: segmentedControlVisible)
    }
    
    func request(_ segmentIndex: Int) -> Observable<[PosterItemViewModel]> {
        var results: Observable<[_Content]> = Observable.just([])
        
        if !contents.isEmpty && page == 1 {
            results = Observable.just(contents)
        } else {
            switch sectionType {
            case let .movieChart(movieChart):
                results = networkService.movies(chart: movieChart, page: page).mapToContents()
            case let .tvShowChart(tvShowChart):
                results = networkService.tvShows(chart: tvShowChart, page: page).mapToContents()
            case let .movieInformation(info, id):
                switch info {
                case .recommendation:
                    results = networkService.movieRecommendations(id: id, page: page).mapToContents()
                default:
                    break
                }
            case let .tvShowInformation(info, id):
                switch info {
                case .recommendation:
                    results = networkService.tvShowRecommendations(id: id, page: page).mapToContents()
                default:
                    break
                }
            case .favorites:
                guard let accountID = AuthManager.shared.auth?.accountID else { break }
                switch ContentsType(rawValue: segmentIndex) {
                case .movies:
                    results = networkService.favoriteMovies(accountID: accountID, page: page, sortBy: nil).mapToContents()
                case .tvShows:
                    results = networkService.favoriteTvShows(accountID: accountID, page: page, sortBy: nil).mapToContents()
                default:
                    break
                }
            default:
                break
            }
        }
        Log.i("#id ------------------------------")
        return results
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .map { contents -> [PosterItemViewModel] in
                contents.enumerated().forEach{ Log.i("#id\($0) : \($1.id)") }
                let viewModels = contents.map { PosterItemViewModel(with: $0, heroID: "\($0.id)") }
                return viewModels
            }
    }
}
