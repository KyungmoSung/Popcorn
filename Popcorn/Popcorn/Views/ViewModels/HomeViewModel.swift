//
//  HomeViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/19.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
    typealias HomeSection = _Section<_SectionType.Home, PosterViewModel>

    struct Input {
        let ready: Driver<Void>
//        let changeContentsType: Driver<ContentsType>
        let selectedIndex: Driver<IndexPath>
        let selectedSection: Driver<Int>
    }
    
    struct Output {
        let contents: Driver<[HomeSection]>
        let selectedContentID: Driver<Int>
        let selectedSection: Driver<_SectionType.Home>
    }
    
    func transform(input: Input) -> Output {
        let result = input.ready
            .asObservable()
            .flatMap {
                Observable.zip(self.fetchPopular().asObservable(),
                               self.fetchTopRated().asObservable())
            }
            .map { popular, topRated in
                return [popular, topRated]
            }
            .asDriver(onErrorJustReturn: [])
        
        let selectedContentsID = input.selectedIndex
            .withLatestFrom(result) { indexPath, result in
                return result[indexPath.section].items[indexPath.row].id
            }
        
        let selectedSection = input.selectedSection
            .withLatestFrom(result) { section, result in
                return result[section].sectionType
            }
        
        return Output(contents: result, selectedContentID: selectedContentsID, selectedSection: selectedSection)
    }
    
    func fetchPopular() -> Single<HomeSection> {
        return Single.create { single in
            let params: [String: Any] = [
                "page": 1
            ]
            
            APIManager.request(AppConstants.API.Movie.getPopular, method: .get, params: params, responseType: PageResponse<_Movie>.self) { (result) in
                switch result {
                case .success(let response):
                    guard let items = response.results else {
                        return
                    }
                    
                    let viewModels = items.map {
                        PosterViewModel(with: $0)
                    }
                    let section = HomeSection(sectionType: .movie(.popular), items: viewModels)
                    single(.success(section))
                case .failure(let error):
                    Log.d(error)
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    
    func fetchTopRated() -> Single<HomeSection> {
        return Single.create { single in
            let params: [String: Any] = [
                "page": 1
            ]
            
            APIManager.request(AppConstants.API.Movie.getTopRated, method: .get, params: params, responseType: PageResponse<_Movie>.self) { (result) in
                switch result {
                case .success(let response):
                    guard let items = response.results else {
                        return
                    }
                    
                    let viewModels = items.map {
                        PosterViewModel(with: $0)
                    }
                    let section = HomeSection(sectionType: .movie(.topRated), items: viewModels)

                    single(.success(section))
                case .failure(let error):
                    Log.d(error)
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
