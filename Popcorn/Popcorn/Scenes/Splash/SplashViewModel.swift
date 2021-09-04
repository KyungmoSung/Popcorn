//
//  SplashViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/01.
//

import UIKit
import RxSwift
import RxCocoa

class SplashViewModel: ViewModelType {
    struct Input {
        let ready: Driver<Void>
    }
    
    struct Output {
        let settingConfig: Driver<Void>
    }
    
    private let networkService: TmdbService
    private let coordinator: SplashCoodinator
    
    init(networkService: TmdbService = TmdbAPI(), coordinator: SplashCoodinator) {
        self.networkService = networkService
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {
        // Config API - 탭바 화면 이동
        let config = input.ready.asObservable()
            .debug()
            .flatMap {
                Observable.zip(self.networkService.languages(),
                               self.networkService.countries(),
                               self.networkService.genres(type: .movies),
                               self.networkService.genres(type: .tvShows))
            }
            .map { languages, countries, movieGenres, tvGenres in
                Language.allCases = languages
                Country.allCases = countries
                Genre.allCases[.movies] = movieGenres
                Genre.allCases[.tvShows] = tvGenres
            }
            .asDriver(onErrorJustReturn: ())
            .do(onNext: coordinator.showTabBar)
            
        return Output(settingConfig: config)
    }
}
