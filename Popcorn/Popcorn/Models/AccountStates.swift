//
//  AccountStates.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/08.
//

import Foundation

// MARK: - AccountStates
struct AccountStates: Codable {
    let id: Int?
    var rated: AnyValue?
    var favorite: Bool
    var watchlist: Bool

    init() {
        id = nil
        rated = nil
        favorite = false
        watchlist = false
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case rated = "rated"
        case favorite = "favorite"
        case watchlist = "watchlist"
    }
}

// MARK: - Rated
struct Rated: Codable {
    let value: Int?

    enum CodingKeys: String, CodingKey {
        case value = "value"
    }
}
