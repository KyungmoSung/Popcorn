//
//  BaseViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/15.
//

import Foundation
import RxSwift
import RxDataSources

typealias ViewModel = BaseViewModel & ViewModelType

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol RowViewModelType: IdentifiableType, Equatable {}

class BaseViewModel {
    var disposeBag = DisposeBag()
    
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    
    let networkService: TmdbService
    
    init(networkService: TmdbService) {
        self.networkService = networkService
    }
}
