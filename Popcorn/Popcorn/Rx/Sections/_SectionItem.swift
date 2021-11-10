//
//  _SectionItem.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/18.
//

import Foundation
import RxDataSources

//struct _SectionItem<T: _SectionType, E> {
//    var section: T
//    var items: [Item]
//}
//
//extension _SectionItem: SectionModelType {
//    typealias Item = E
//
//    init(original: _SectionItem, items: [E]) {
//        self = original
//        self.items = items
//    }
//}

struct _SectionItem<T: _SectionType, E: IdentifiableType & Equatable> {
    var section: T
    var items: [Item]
}

extension _SectionItem : AnimatableSectionModelType {
    typealias Item = E

    var identity: String {
        return section.title ?? ""
    }

    init(original: _SectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
