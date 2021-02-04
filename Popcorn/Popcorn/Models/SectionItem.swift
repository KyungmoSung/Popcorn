//
//  SectionItem.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import Foundation

class SectionItem: NSObject, ListDiffable {
    var sectionType: SectionType
    var items: [ListDiffable]
    
    init(_ sectionType: SectionType, items: [ListDiffable] = []) {
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
