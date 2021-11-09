//
//  SignViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/01.
//

import Foundation
import RxSwift

class SignViewModel: ViewModel {
    struct Input {
        let signTrigger: Observable<Void>
    }
    
    struct Output {
        let signInSuccess: Observable<Void>
    }
    
    private let coordinator: SignCoordinator
    
    init(networkService: TmdbService, coordinator: SignCoordinator) {
        self.coordinator = coordinator
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
        input.signTrigger
            .subscribe(onNext: {
                AuthManager.shared.openSignURL()
            })
            .disposed(by: disposeBag)
        
        let result = AuthManager.shared.signResult
            .filter{ $0 == true }
            .mapToVoid()
            .do(onNext: coordinator.dismiss)
        
        return Output(signInSuccess: result)
    }
}
