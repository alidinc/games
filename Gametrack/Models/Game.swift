//
//  Game.swift
//  A-games
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftUI

// MARK: - ResponseElement

struct Game: Codable, Equatable, Identifiable, Hashable {
    
    let id: Int
    let cover: Cover?
    let firstReleaseDate: Int?
    let genres: [Genre]?
    let name: String?
    let platforms: [Platform]?
    let releaseDates: [ReleaseDate]?
    let screenshots: [Cover]?
    let summary: String?
    let totalRating: Double?
    let versionTitle: String?
    let ratingCount: Int?
    let gameModes: [GameMode]?
    let videos: [Video]?
    let websites: [Website]?
    let similarGames: [Int]?
    let artworks: [Artwork]?
    let involvedCompanies: [Int]?
    
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
        case versionTitle = "version_title"
        case similarGames = "similar_games"
        case involvedCompanies = "involved_companies"
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(
        id: Int,
        cover: Cover? = nil,
        firstReleaseDate: Int? = nil,
        genres: [Genre]? = nil,
        name: String? = nil,
        platforms: [Platform]? = nil,
        releaseDates: [ReleaseDate]? = nil,
        screenshots: [Cover]? = nil,
        summary: String? = nil,
        totalRating: Double? = nil,
        versionTitle: String? = nil,
        ratingCount: Int? = nil,
        gameModes: [GameMode]? = nil,
        videos: [Video]? = nil,
        websites: [Website]? = nil,
        similarGames: [Int]? = nil,
        artworks: [Artwork]? = nil,
        involvedCompanies: [Int]? = nil
    ) {
        self.id = id
        self.cover = cover
        self.firstReleaseDate = firstReleaseDate
        self.genres = genres
        self.name = name
        self.platforms = platforms
        self.releaseDates = releaseDates
        self.screenshots = screenshots
        self.summary = summary
        self.totalRating = totalRating
        self.versionTitle = versionTitle
        self.ratingCount = ratingCount
        self.gameModes = gameModes
        self.videos = videos
        self.websites = websites
        self.similarGames = similarGames
        self.artworks = artworks
        self.involvedCompanies = involvedCompanies
    }
}

// MARK: - Artwork
struct Artwork: Codable, Hashable {
    let id: Int?
    let url: String?
}

// MARK: - Cover
struct Cover: Codable, Hashable {
    let game: Int?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case game
        case url
    }
}

// MARK: - GameMode
struct GameMode: Codable, Hashable {
    let id: Int?
    let name: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
    }
}

// MARK: - Genre
struct Genre: Codable, Hashable {
    let id: Int
    let name: String?
}

// MARK: - Platform
struct Platform: Codable, Hashable {
    let id: Int?
    let abbreviation: String?
    let name: String?
    let platformLogo: Int?
    let summary: String?
    
    enum CodingKeys: String, CodingKey {
        case abbreviation, id
        case name
        case platformLogo = "platform_logo"
        case summary
    }
    
    var popularPlatform: PopularPlatform? {
        guard let id = self.id,
              let platform = PopularPlatform(rawValue: id) else {
            return nil
        }
        
        return platform
    }
}

// MARK: - ReleaseDate
struct ReleaseDate: Codable, Hashable, Comparable {
    let id, date: Int?
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
    let id, game: Int?
    let name, videoID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, game, name
        case videoID = "video_id"
    }
}

// MARK: - Website
struct Website: Codable, Hashable {
    let id, category, game: Int?
    let trusted: Bool?
    let url: String?
    let checksum: String?
    
    var platformWebsite: PlatformWebsite? {
        guard let category = self.category,
              let platformWebsite = PlatformWebsite(rawValue: category) else {
            return nil
        }
        
        return platformWebsite
    }
}

// MARK: - Company
struct Company: Codable, Hashable {
    let id, changeDateCategory, createdAt: Int
    let name, slug: String
    let startDateCategory, updatedAt: Int
    let url: String
    let checksum: String
    let developed, published: [Int]?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case changeDateCategory = "change_date_category"
        case createdAt = "created_at"
        case name, slug
        case startDateCategory = "start_date_category"
        case updatedAt = "updated_at"
        case url, checksum, developed, published, description
    }
}


struct SimilarGame: Codable, Equatable, Identifiable, Hashable {
    
    let id: Int
    let cover: Cover?
    let firstReleaseDate: Int?
    let genres: [Genre]?
    let name: String?
    let platforms: [Platform]?
    let releaseDates: [ReleaseDate]?
    let screenshots: [Cover]?
    let summary: String?
    let totalRating: Double?
    let versionTitle: String?
    let ratingCount: Int?
    let gameModes: [GameMode]?
    let videos: [Video]?
    let websites: [Website]?
    let similarGames: [Int]?
    let artworks: [Artwork]?
    let involvedCompanies: [Int]?
    
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
        case versionTitle = "version_title"
        case similarGames = "similar_games"
        case involvedCompanies = "involved_companies"
    }
    
    static func == (lhs: SimilarGame, rhs: SimilarGame) -> Bool {
        return lhs.id == rhs.id
    }
}
