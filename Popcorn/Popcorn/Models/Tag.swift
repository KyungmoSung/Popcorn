//
//  Tag.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/24.
//

import Foundation

class Tag: Loadingable {
    var id: Int!
    var name: String!
    
    var isLoading: Bool = false
    
    init(id: Int, name: String, isLoading: Bool) {
        self.id = id
        self.name = name
        self.isLoading = isLoading
    }
}

extension Tag: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
