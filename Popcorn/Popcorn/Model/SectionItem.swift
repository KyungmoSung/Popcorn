//
//  SectionItem.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import Foundation

class SectionItem<T: RawRepresentable & SectionType>: NSObject, ListDiffable {
    let sectionType: T
    var items: [ListDiffable]
    
    init(_ sectionType: T, items: [ListDiffable] = []) {
        self.sectionType = sectionType
        self.items = items
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? SectionItem else {
            return false
        }

        return self === object
    }
}

typealias DetailSectionItem = SectionItem<Section.Detail>
typealias HomeSectionItem = SectionItem<Section.Home>
typealias ContentsSectionItem = SectionItem<ImageType>
