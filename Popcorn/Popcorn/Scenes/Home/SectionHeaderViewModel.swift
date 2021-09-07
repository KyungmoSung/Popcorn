//
//  SectionHeaderViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/30.
//

import Foundation
import RxSwift
import RxCocoa

final class SectionHeaderViewModel {
    let section: _SectionType
    let index: Int
    
    init(with section: _SectionType, index: Int) {
        self.section = section
        self.index = index
    }
}
