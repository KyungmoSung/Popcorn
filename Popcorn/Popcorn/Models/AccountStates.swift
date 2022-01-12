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
    var favorite: Bool
    var watchlist: Bool
    private var ratedInfo: AnyValue?
    
    var rated: Double? {
        return ratedInfo?.dictValue?["value"]?.doubleValue
    }

    init() {
        id = nil
        ratedInfo = nil
        favorite = false
        watchlist = false
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ratedInfo = "rated"
        case favorite = "favorite"
        case watchlist = "watchlist"
    }
}
