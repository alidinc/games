//
//  AccessToken.swift
//  Speeltuin
//
//  Created by Ali Dinç on 04/12/2022.
//

import Foundation

struct AccessToken: Codable {
    
    let token: String
    let expiryInSeconds: Int
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case expiryInSeconds = "expires_in"
        case type = "token_type"
    }
}
