//
//  _SectionItem.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/18.
//

import Foundation
import RxDataSources

struct SectionItem<T: SectionType, E: IdentifiableType & Equatable> {
    var section: T
    var items: [Item]
}

extension SectionItem : AnimatableSectionModelType {
    typealias Item = E

    var identity: String {
        return section.title ?? ""
    }

    init(original: SectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
