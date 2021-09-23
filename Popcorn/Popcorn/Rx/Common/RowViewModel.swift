//
//  RowViewModel.swift
//  RowViewModel
//
//  Created by Kyungmo on 2021/09/23.
//

import Foundation
import RxSwift
import RxDataSources

class RowViewModel: IdentifiableType & Equatable {
    typealias Identity = String
    
    lazy var disposeBag = DisposeBag()
    
    let identity: String
    
    init(identity: String) {
        self.identity = identity
    }
    
    static func == (lhs: RowViewModel, rhs: RowViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}
