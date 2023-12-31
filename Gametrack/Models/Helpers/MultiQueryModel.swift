//
//  MultiQueryModel.swift
//  GoodGames
//
//  Created by Ali Dinç on 05/01/2023.
//

import Foundation

struct MultiQueryModel: Codable {
    let name: String?
    let result: [Game]?
}

struct MultiQueryCountModel: Codable {
    let name: String
    let count: Int
}
