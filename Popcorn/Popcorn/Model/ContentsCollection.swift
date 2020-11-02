//
//  ContentsCollection.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import Foundation

enum ContentsCategory: String {
    case nowPlaying
    case popular
    case topRated
    case latest
    case upcoming
    
    var title: String {
        return self.rawValue.localized
    }
}

class ContentsCollection: NSObject, ListDiffable {
    let category: ContentsCategory
    let contents: [Movie]
    
    init(category: ContentsCategory, contents: [Movie]) {
        self.category = category
        self.contents = contents
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
}
