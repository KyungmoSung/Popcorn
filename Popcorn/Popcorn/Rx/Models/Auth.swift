//
//  Auth.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/10/27.
//

import Foundation

// MARK: - Auth
struct Auth: Codable {
    let statusMessage: String?
    let requestToken: String?
    let success: Bool?
    let statusCode: Int?
    let accountID: String?
    let accessToken: String?
    let sessionID: String?

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

