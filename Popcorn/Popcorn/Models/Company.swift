//
//  Company.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/07.
//

import Foundation

// MARK: - Network
struct Company: Codable {
    var name: String?
    var id: Int?
    var logoPath: String?
    var originCountry: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
