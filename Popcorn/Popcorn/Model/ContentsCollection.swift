//
//  ContentsCollection.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import Foundation

enum ContentsCategory: String {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case topRated = "Top Rated"
    case latest = "Latest"
    case upcoming = "Upcoming"
    
    var name: String {
        return self.rawValue
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
