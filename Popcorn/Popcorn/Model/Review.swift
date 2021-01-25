//
//  Review.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/27.
//

import Foundation

// MARK: - Review
class Review: Codable, ListDiffable {
    let id: String
    let author: String?
    let authorDetails: Author
    let content: String
    let createdAt: AnyValue?
    let updatedAt: AnyValue?
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

// MARK: - AuthorDetails
class Author: Codable {
    let username: String
    let name: String?
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}
