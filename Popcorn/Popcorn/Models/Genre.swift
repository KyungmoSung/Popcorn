//
//  Genre.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/11.
//

import Foundation

class Genre: Loadingable, Codable {
    var id: Int!
    var name: String!
    
    var isLoading: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(id: Int, name: String = "", isLoading: Bool) {
        self.id = id
        self.name = name
        self.isLoading = isLoading
    }
}

extension Genre: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return (lhs.id == rhs.id) && (lhs.name == rhs.name)
    }
}
