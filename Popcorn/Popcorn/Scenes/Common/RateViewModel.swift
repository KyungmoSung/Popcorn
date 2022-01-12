//
//  RateViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/19.
//

import Foundation
import RxSwift

class RateViewModel: ViewModel {
    struct Input {
        let ready: Observable<Void>
        let rateValue: Observable<Float>
        let save: Observable<Void>
        let delete: Observable<Void>
        let dismiss: Observable<Void>
    }
    
    struct Output {
        let rate: Observable<Int>
        let starImageNames: Observable<[String]>
        let saveEnable: Observable<Bool>
        let deleteHidden: Observable<Bool>
    }
    
    private let coordinator: RateCoordinator
    private let rated: Double?
    private let content: Content
    
    init(with content: Content, rated: Double?, networkService: TmdbService, coordinator: RateCoordinator) {
        self.content = content
        self.rated = rated
        self.coordinator = coordinator
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
        // 평점 등록
        input.save.withLatestFrom(input.rateValue)
            .map{ Int(round($0)) }
            .flatMap { [weak self] value -> Observable<Void> in
                guard let self = self, let sessionID = AuthManager.shared.auth?.sessionID else {
                    return .empty()
                }
                
                return self.networkService.rate(sessionID: sessionID,
                                                type: self.content.contentType,
                                                id: self.content.id,
                                                rateValue: value)
            }
            .subscribe(onNext: {
                self.coordinator.dismiss()
            })
            .disposed(by: disposeBag)
        
        // 평점 삭제
        input.delete
            .flatMap { [weak self] value -> Observable<Void> in
                guard let self = self, let sessionID = AuthManager.shared.auth?.sessionID else {
                    return .empty()
                }
                
                return self.networkService.deleteRating(sessionID: sessionID,
                                                        type: self.content.contentType,
                                                        id: self.content.id)
            }
            .subscribe(onNext: {
                self.coordinator.dismiss()
            })
            .disposed(by: disposeBag)

        // 화면 종료
        input.dismiss
            .subscribe { _ in
                self.coordinator.dismiss()
            }
            .disposed(by: disposeBag)
        
        // 등록되어있는 평점
        let rate = input.rateValue
            .skip(1)
            .map{ Int(round($0)) }
            .startWith(Int(self.rated ?? 0))
        
        // 슬라이더 값에 따라 세팅할 Star 이미지
        let starImageNames = input.rateValue
            .map{ Int(round($0)) }
            .map{ value -> [String] in
                var imageNames: [String] = []
                for i in 0..<5 {
                    let fill = value / 2 > i
                    let half = value / 2 == i && (value % 2) > 0
                    
                    switch (fill, half) {
                    case (true, _):
                        imageNames.append("icStarFill")
                    case (false, true):
                        imageNames.append("icStarHalf")
                    case (false, false):
                        imageNames.append("icStarBorder")
                    }
                }
                return imageNames
            }
        
        // 저장버튼 활성화 여부
        let saveEnable = input.rateValue
            .map{ $0 > 0 }
        
        // 삭제버튼 표시 여부
        let deleteHidden = Observable.just(rated)
            .map{ $0 == nil }
        
        
        return Output(rate: rate, starImageNames: starImageNames, saveEnable: saveEnable, deleteHidden: deleteHidden)
    }
}
