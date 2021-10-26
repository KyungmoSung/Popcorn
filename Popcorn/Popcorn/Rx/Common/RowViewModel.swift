//
//  RowViewModel.swift
//
//  Created by Kyungmo on 2021/09/23.
//

import Foundation
import RxSwift
import RxDataSources

class RowViewModel {
    lazy var disposeBag = DisposeBag()

    let identity: String

    init(identity: String) {
        self.identity = identity
    }
    
    init(identity: Int) {
        self.identity = "\(identity)"
    }
}

extension RowViewModel: IdentifiableType, Equatable {
    typealias Identity = String
    
    static func == (lhs: RowViewModel, rhs: RowViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}
