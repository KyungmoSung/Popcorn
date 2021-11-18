//
//  User.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/10/29.
//

import Foundation

// MARK: - User
struct User: Codable {
    let avatar: Avatar?
    let id: Int?
    let iso639_1: String?
    let iso3166_1: String?
    let name: String?
    let includeAdult: Bool?
    let username: String?

    enum CodingKeys: String, CodingKey {
        case avatar = "avatar"
        case id = "id"
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name = "name"
        case includeAdult = "include_adult"
        case username = "username"
    }
}

// MARK: - Avatar
struct Avatar: Codable {
    let gravatar: Gravatar?
}

// MARK: - Gravatar
struct Gravatar: Codable {
    let hash: String?
}
