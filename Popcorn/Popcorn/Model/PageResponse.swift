//
//  PageResponse.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Foundation

struct PageResponse<T: Codable>: Codable {
    let page: Int?
    let results: [T]?
    let totalResults: Int?
    let totalPages: Int?
    
    enum CodingKeys : String, CodingKey{
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
