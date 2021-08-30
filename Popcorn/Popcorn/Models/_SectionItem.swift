//
//  _SectionItem.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/18.
//

import Foundation
import RxDataSources

struct _SectionItem<T: Equatable, E> {
    var section: T
    var items: [Item]
}

extension _SectionItem: SectionModelType {
    typealias Item = E
    
    init(original: _SectionItem, items: [E]) {
        self = original
        self.items = items
    }
}
