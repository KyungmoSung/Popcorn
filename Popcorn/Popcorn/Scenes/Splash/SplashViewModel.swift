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
        let config = input.ready
            .delay(5)
            .asDriver()
            .do(onNext: coordinator.showTabBar)
            
        return Output(settingConfig: config)
    }
}
