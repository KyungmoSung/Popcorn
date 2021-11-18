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
        let sortSelection: Observable<Sort?>
    }
    
    struct Output {
        let loading: Observable<Bool>
        let title: Observable<String>
        let sectionItems: Observable<[ListSectionItem]>
        let selectedContent: Observable<_Content>
        let segmentedControlVisible: Observable<Bool>
        let sorts: Observable<[Sort]?>
    }

    private var page = 1
    private var hasNextPage: Bool = false
    private var sectionType: ListSection
    private let coordinator: ContentListCoordinator
    
    init(with sectionType: ListSection, networkService: TmdbService = TmdbAPI(), coordinator: ContentListCoordinator) {
        self.sectionType = sectionType
        self.coordinator = coordinator
        
        super.init(networkService: networkService)
    }

    func transform(input: Input) -> Output {
        let sectionItems = BehaviorSubject<[ListSectionItem]>(value: [
            ListSectionItem(section: sectionType, items: [])
        ])
                
        // 화면 진입, 세그먼트 선택, 정렬옵션 선택시 초기화
        Observable.combineLatest(input.ready,
                                 input.segmentSelection,
                                 input.sortSelection)
            .flatMap { [weak self] _, segmentIndex, sort -> Observable<[PosterItemViewModel]> in
                guard let self = self else { return Observable.just([]) }

                self.page = 1
                return self.request(segmentIndex, sortBy: sort)
            }
            .subscribe(onNext: { viewModels in
                if var sectionItem = try? sectionItems.value().first {
                    sectionItem.items = viewModels
                    sectionItems.onNext([sectionItem])
                }
            })
            .disposed(by: disposeBag)
        
        // 스크롤시 다음페이지 요청
        Observable.combineLatest(input.scrollToBottom.withLatestFrom(activityIndicator),
                                 input.segmentSelection,
                                 input.sortSelection)
            .flatMap { [weak self] loading, segmentIndex, sort -> Observable<[PosterItemViewModel]> in
                guard let self = self else { return Observable.just([]) }
                
                if self.hasNextPage, !loading {
                    self.page += 1
                    return self.request(segmentIndex, sortBy: sort)
                } else {
                    return Observable.empty()
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
        
        // 정렬 옵션
        let sorts = input.segmentSelection
            .compactMap{ ContentsType(rawValue: $0) }
            .map { self.sectionType.sortOptions(for: $0) }
        
        // 셀 선택 - 디테일 화면 이동
        let selectedContent = input.selection
            .withLatestFrom(sectionItems) { indexPath, result in
                let viewModel = result[indexPath.section].items[indexPath.row]
                return (viewModel.content, viewModel.posterHeroId)
            }
            .do(onNext: coordinator.showDetail)
            .map { $0.0 }
        
        // 네비게이션 타이틀
        let title = Observable.just(sectionType.title).compactMap{ $0 }
        
        // 세그먼트 표시 여부
        // TODO: 세그먼트, 정렬 옵션 분리
        let segmentedControlVisible: Observable<Bool>
        if sectionType.segmentTitles.isNilOrEmpty {
            segmentedControlVisible = .just(false)
        } else {
            segmentedControlVisible = .just(true)
        }
        
        return Output(loading: activityIndicator.asObservable(), title: title, sectionItems: sectionItems, selectedContent: selectedContent, segmentedControlVisible: segmentedControlVisible, sorts: sorts
        )
    }
    
    func request(_ segmentIndex: Int, sortBy sort: Sort?) -> Observable<[PosterItemViewModel]> {
        var results: Observable<(Bool, [_Content]?)> = Observable.just((false, []))
        
        switch sectionType {
        case let .movieChart(movieChart):
            results = networkService.movies(chart: movieChart,
                                            page: page)
                .map{ ($0.hasNextPage, $0.results) }
        case let .tvShowChart(tvShowChart):
            results = networkService.tvShows(chart: tvShowChart,
                                             page: page)
                .map{ ($0.hasNextPage, $0.results) }
        case let .movieInformation(info, id):
            switch info {
            case .recommendation:
                results = networkService.movieRecommendations(id: id,
                                                              page: page)
                    .map{ ($0.hasNextPage, $0.results) }
            default:
                break
            }
        case let .tvShowInformation(info, id):
            switch info {
            case .recommendation:
                results = networkService.tvShowRecommendations(id: id,
                                                               page: page)
                    .map{ ($0.hasNextPage, $0.results) }
            default:
                break
            }
        case .favorites:
            guard let accountID = AuthManager.shared.auth?.accountID else { break }
            switch ContentsType(rawValue: segmentIndex) {
            case .movies:
                results = networkService.favoriteMovies(accountID: accountID,
                                                        page: page,
                                                        sortBy: sort)
                    .map{ ($0.hasNextPage, $0.results) }
            case .tvShows:
                results = networkService.favoriteTvShows(accountID: accountID,
                                                         page: page,
                                                         sortBy: sort)
                    .map{ ($0.hasNextPage, $0.results) }
            default:
                break
            }
        default:
            break
        }
        
        return results
            .map { [weak self] hasNextPage, contents -> [PosterItemViewModel] in
                guard let self = self else { return [] }
                
                self.hasNextPage = hasNextPage
                let viewModels = contents?.map { PosterItemViewModel(with: $0, heroID: "\($0.id)") }
                return viewModels ?? []
            }
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
}
