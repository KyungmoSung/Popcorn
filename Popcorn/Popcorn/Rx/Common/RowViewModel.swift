//
//  RowViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/10/19.
//

import Foundation
import RxSwift
import RxDataSources

protocol RowViewModelType: IdentifiableType, Equatable {}

class RowViewModel {
    var disposeBag = DisposeBag()
    
    let identifier: String
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    init(identifier: Int) {
        self.identifier = "\(identifier)"
    }
}

extension RowViewModel: RowViewModelType {
    typealias Identity = String
    
    var identity: Identity {
        return identifier
    }
    
    static func == (lhs: RowViewModel, rhs: RowViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
