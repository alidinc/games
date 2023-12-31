//
//  Game.swift
//  A-games
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftData
import SwiftUI

// MARK: - Game
struct Game: Codable, Identifiable, Hashable {
    
    let id: Int?
    let name: String?
    let cover: Cover?
    let firstReleaseDate: Int?
    let summary: String?
    let totalRating: Double?
    let ratingCount: Int?
    let genres: [Genre]?
    let platforms: [Platform]?
    let releaseDates: [ReleaseDate]?
    let screenshots: [Cover]?
    let gameModes: [GameMode]?
    let videos: [Video]?
    let websites: [Website]?
    let similarGames: [Int]?
    let artworks: [Artwork]?
    
    enum CodingKeys: String, CodingKey {
        case id, cover, artworks
        case firstReleaseDate = "first_release_date"
        case genres, name, platforms
        case releaseDates = "release_dates"
        case screenshots, summary
        case totalRating = "total_rating"
        case ratingCount = "rating_count"
        case gameModes = "game_modes"
        case videos, websites
        case similarGames = "similar_games"
    }
}

// MARK: - Artwork
struct Artwork: Codable, Hashable {
    let id: Int?
    let url: String?
    
    enum CodingKeys: CodingKey {
        case id
        case url
    }
}

// MARK: - Cover
struct Cover: Codable, Hashable {
    let id: Int?
    let url: String?
    
    enum CodingKeys: CodingKey {
        case id
        case url
    }
}

// MARK: - GameMode
struct GameMode: Codable, Hashable {
    let id: Int?
    let name: String?
    let url: String?
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case url
    }
}

// MARK: - Genre
struct Genre: Codable, Hashable {
    let id: Int?
    let name: String?
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
}

// MARK: - Platform
struct Platform: Codable, Hashable {
    let id: Int?
    let abbreviation: String?
    let name: String?
    let platformLogo: Int?
    let summary: String?
    
    enum CodingKeys: String, CodingKey {
        case abbreviation
        case id
        case name
        case platformLogo = "platform_logo"
        case summary
    }
}

// MARK: - ReleaseDate
struct ReleaseDate: Codable, Hashable, Comparable {
    let id: Int?
    let date: Int?
    let game: Int?
    let human: String?
    let platform: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date, game, human, platform
    }
    
    static func < (lhs: ReleaseDate, rhs: ReleaseDate) -> Bool {
        return lhs.date ?? 0 < rhs.date ?? 0
    }
}

// MARK: - Video
struct Video: Codable, Hashable {
    let id: Int?
    let videoID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case videoID = "video_id"
    }
}

// MARK: - Website
struct Website: Codable, Hashable {
    let id: Int?
    let category: Int?
    let url: String?
    
    enum CodingKeys: CodingKey {
        case id
        case category
        case url
    }
}
