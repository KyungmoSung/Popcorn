//
//  ContentsCollection.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import Foundation

class ContentsCollection: NSObject, ListDiffable {
    let homeSection: Section.Home
    var contents: [Movie]
    
    init(homeSection: Section.Home, contents: [Movie] = []) {
        self.homeSection = homeSection
        self.contents = contents
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ContentsCollection else {
            return false
        }

        return self.homeSection == object.homeSection && self.contents == object.contents
    }
}
