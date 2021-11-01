//
//  SplashViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/01.
//

import UIKit
import RxSwift

class SplashViewModel: ViewModel {
    struct Input {
        let ready: Observable<Void>
    }
    
    struct Output {
        let settingConfig: Observable<Void>
    }
    
    private let coordinator: SplashCoodinator
    
    init(networkService: TmdbService = TmdbAPI(), coordinator: SplashCoodinator) {
        self.coordinator = coordinator
        
        super.init(networkService: networkService)
    }

    func transform(input: Input) -> Output {
        // Config API - 탭바 화면 이동
        let config = input.ready.asObservable()
            .debug()
            .flatMap { [weak self] _ -> Observable<([Language], [Country], [Genre], [Genre])> in
                guard let self = self else { return Observable.empty() }
                
                return Observable.zip(self.networkService.languages()
                                        .trackActivity(self.activityIndicator)
                                        .trackError(self.errorTracker),
                                      self.networkService.countries()
                                        .trackActivity(self.activityIndicator)
                                        .trackError(self.errorTracker),
                                      self.networkService.genres(type: .movies)
                                        .trackActivity(self.activityIndicator)
                                        .trackError(self.errorTracker),
                                      self.networkService.genres(type: .tvShows)
                                        .trackActivity(self.activityIndicator)
                                        .trackError(self.errorTracker))
            }
            .map { languages, countries, movieGenres, tvGenres in
                Language.allCases = languages
                Country.allCases = countries
                Genre.allCases[.movies] = movieGenres
                Genre.allCases[.tvShows] = tvGenres
            }
            .do(onNext: coordinator.showTabBar)
            
        return Output(settingConfig: config)
    }
}
