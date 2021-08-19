//
//  _Section.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/18.
//

import Foundation
import RxDataSources

struct _Section<T, E> {
    var sectionType: T
    var items: [Item]
}

extension _Section: SectionModelType {
    typealias Item = E
    
    init(original: _Section, items: [E]) {
        self = original
        self.items = items
    }
}
