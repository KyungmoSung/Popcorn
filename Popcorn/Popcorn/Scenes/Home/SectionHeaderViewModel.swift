//
//  SectionHeaderViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/30.
//

import Foundation
import RxSwift
import RxCocoa

final class SectionHeaderViewModel: ViewModelType {
    struct Input {
        let selection: Driver<Int>
    }
    
    struct Output {
        let selectedIndex: Driver<Int>
    }
    
    let section: _SectionType
    
    init(with section: _SectionType) {
        self.section = section
    }
    
    func transform(input: Input) -> Output {
        return Output(selectedIndex: Driver<Int>.empty())
    }
}
