//
//  Auth.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/10/27.
//

import Foundation

// MARK: - Auth
struct Auth: Codable {
    var statusMessage: String?
    var requestToken: String?
    var success: Bool?
    var statusCode: Int?
    var accountID: String?
    var accessToken: String?
    var sessionID: String?

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case requestToken = "request_token"
        case success = "success"
        case statusCode = "status_code"
        case accountID = "account_id"
        case accessToken = "access_token"
        case sessionID = "session_id"
    }
}

