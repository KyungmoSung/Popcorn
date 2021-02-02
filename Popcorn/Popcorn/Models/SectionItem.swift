//
//  SectionItem.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import Foundation

protocol ListDiffableItems: ListDiffable {
    var items: [ListDiffable] { get set }
}

protocol ListDiffableSectionItem: ListDiffableItems {
    associatedtype SectionType

    var sectionType: SectionType { get set }
}

class SectionItem<T: SectionType>: NSObject, ListDiffableSectionItem {
    var sectionType: T
    var items: [ListDiffable]
    
    init(_ sectionType: T, items: [ListDiffable] = []) {
        self.sectionType = sectionType
        self.items = items
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object
    }
}
typealias ContentsSectionItem = SectionItem<Section.ContentsType>
typealias HomeSectionItem = SectionItem<Section.Home>
typealias DetailSectionItem =  SectionItem<Section.Detail>

