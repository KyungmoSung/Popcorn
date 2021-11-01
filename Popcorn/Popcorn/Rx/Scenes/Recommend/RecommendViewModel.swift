//
//  RecommendViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/01.
//

import Foundation
import RxSwift

class RecommendViewModel: ViewModel {
    struct Input {
        let ready: Observable<Void>
    }
    
    struct Output {
        let needSignIn: Observable<Bool>
    }
    
    private let coordinator: RecommendCoordinator
    
    init(networkService: TmdbService, coordinator: RecommendCoordinator) {
        self.coordinator = coordinator
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
        let isSignIn = input.ready
            .map{ AuthManager.shared.isSignIn() }
        
        // 미로그인시 로그인으로 이동
        let needSignIn = isSignIn
            .do(onNext: { isSignIn in
                if !isSignIn {
                    self.coordinator.showSignIn()
                }
            })
        
        return Output(needSignIn: needSignIn)
    }
}
