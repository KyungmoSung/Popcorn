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

protocol SectionItem: ListDiffableItems {
    associatedtype SectionType

    var sectionType: SectionType { get set }
}

class HomeSectionItem: NSObject, SectionItem {
    var sectionType: Section.Home
    var items: [ListDiffable]
    
    init(_ sectionType: Section.Home, items: [ListDiffable] = []) {
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

class DetailSectionItem: NSObject, SectionItem {
    var sectionType: Section.Detail
    var items: [ListDiffable]
    
    init(_ sectionType: Section.Detail, items: [ListDiffable] = []) {
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
