//
//  TVShow.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/02.
//

import Foundation


// MARK: - Result
class TVShow: Contents {
    var name: String!
    var originalName: String!
    var firstAirDate: AnyValue?
    var originCountry: [ISO_3166_1]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalName = try container.decode(String.self, forKey: .originalName)
        self.firstAirDate = try container.decode(AnyValue.self, forKey: .firstAirDate)
        self.originCountry = try container.decode([ISO_3166_1].self, forKey: .originCountry)
        
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
}
