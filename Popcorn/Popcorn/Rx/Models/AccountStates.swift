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
    let favorite: Bool?
    let rated: AnyValue?
    let watchlist: Bool?

    init() {
        id = nil
        favorite = nil
        rated = nil
        watchlist = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case favorite = "favorite"
        case rated = "rated"
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
