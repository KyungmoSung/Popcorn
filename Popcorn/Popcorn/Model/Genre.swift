//
//  Genre.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/11.
//

import Foundation

class Genre: Codable {
    let id: Int!
    let name: String!
}

extension Genre: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
