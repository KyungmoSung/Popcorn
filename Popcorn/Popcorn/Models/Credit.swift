//
//  Credit.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/02/18.
//

import Foundation


class MovieCredit: Movie {
    var creditID: String?
    var character: String?
    var department: String?
    var job: String?
    
    enum CodingKeys : String, CodingKey{
        case creditID = "credit_id"
        case character
        case department
        case job
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.creditID = try container.decodeIfPresent(String.self, forKey: .creditID)
        self.character = try container.decodeIfPresent(String.self, forKey: .character)
        self.department = try container.decodeIfPresent(String.self, forKey: .department)
        self.job = try container.decodeIfPresent(String.self, forKey: .job)

        try super.init(from: decoder)
    }
}

class TVShowCredit: TVShow {
    var creditID: String?
    var character: String?
    var department: String?
    var job: String?
    
    enum CodingKeys : String, CodingKey{
        case creditID = "credit_id"
        case character
        case department
        case job
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.creditID = try container.decodeIfPresent(String.self, forKey: .creditID)
        self.character = try container.decodeIfPresent(String.self, forKey: .character)
        self.department = try container.decodeIfPresent(String.self, forKey: .department)
        self.job = try container.decodeIfPresent(String.self, forKey: .job)

        try super.init(from: decoder)
    }
}
