//
//  Credit.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

class Person: Codable, ListDiffable {
    let birthday: String?
    let deathday: String?
    let id: Int!
    let name: String!
    let gender: Int?
    let biography: String!
    let popularity: Double!
    let adult: Bool!
    let homepage: String?
    let knownForDepartment: String!
    let alsoKnownAs: [String]!
    let placeOfBirth: String?
    let profilePath: String?
    let imdbId: String!
    let creditId: String!
    
    private enum CodingKeys : String, CodingKey{
        case birthday
        case deathday
        case id
        case name
        case gender
        case biography
        case popularity
        case adult
        case homepage
        case knownForDepartment = "known_for_department"
        case alsoKnownAs = "also_known_as"
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case imdbId = "imdb_id"
        case creditId = "credit_id"
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

class Cast: Person {
    let castId: Int?
    let character: String!
    let order: Int!

    private enum CodingKeys : String, CodingKey{
        case castId = "cast_id"
        case character
        case order
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        castId = try container.decode(Int.self, forKey: .castId)
        character = try container.decode(String.self, forKey: .character)
        order = try container.decode(Int.self, forKey: .order)
        
        try super.init(from: decoder)
    }
}

class Crew: Person {
    var department: String!
    var job: String!

    private enum CodingKeys : String, CodingKey{
        case department
        case job
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        department = try container.decode(String.self, forKey: .department)
        job = try container.decode(String.self, forKey: .job)
        
        try super.init(from: decoder)
    }
}
