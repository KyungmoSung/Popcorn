//
//  Credit.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

class Person: Codable {
    let id: Int!
    let birthday: AnyValue?
    let deathday: AnyValue?
    let name: String!
    let gender: Int?
    let biography: String?
    let popularity: Double?
    let adult: Bool?
    let homepage: String?
    let knownForDepartment: String?
    let alsoKnownAs: [String]?
    let placeOfBirth: String?
    let profilePath: String?
    let imdbId: String?
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
    
//    var detailInfos: [DetailInfo] {
//        var infoItems: [DetailInfo] = []
//
//        if let birthday = birthday?.stringValue {
//            infoItems.append(DetailInfo(title: "birthday".localized, desc: birthday))
//        }
//
//        if let gender = gender {
//            var genderDesc: String?
//
//            switch gender {
//            case 1:
//                genderDesc = "female".localized
//            case 2:
//                genderDesc = "male".localized
//            default:
//                genderDesc = nil
//            }
//
//            if let genderDesc = genderDesc {
//                infoItems.append(DetailInfo(title: "gender".localized, desc: genderDesc))
//            }
//        }
//
//        if let popularity = popularity {
//            infoItems.append(DetailInfo(title: "popularity".localized, desc: "\(Int(popularity)) 점"))
//        }
//
//        if let knownForDepartment = knownForDepartment {
//            infoItems.append(DetailInfo(title: "knownForDepartment".localized, desc: knownForDepartment))
//        }
//
//        if let placeOfBirth = placeOfBirth {
//            infoItems.append(DetailInfo(title: "placeOfBirth".localized, desc: placeOfBirth))
//        }
//
//        return infoItems
//    }
}

class Cast: Person {
    let castId: Int?
    let character: String?
    let order: Int?

    private enum CodingKeys : String, CodingKey{
        case castId = "cast_id"
        case character
        case order
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        castId = try container.decodeIfPresent(Int.self, forKey: .castId)
        character = try container.decodeIfPresent(String.self, forKey: .character)
        order = try container.decodeIfPresent(Int.self, forKey: .order)
        
        try super.init(from: decoder)
    }
}

class Crew: Person {
    var department: String?
    var job: String?

    private enum CodingKeys : String, CodingKey{
        case department
        case job
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        department = try container.decodeIfPresent(String.self, forKey: .department)
        job = try container.decodeIfPresent(String.self, forKey: .job)
        
        try super.init(from: decoder)
    }
}
