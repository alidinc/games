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
    let similarGames: [Game]?
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
        case versionTitle = "version_title"
        case similarGames = "similar_games"
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
    
    var similarGameCovers: [String] {
        guard let coverURLs = self.similarGames?.compactMap({$0.cover?.url ?? ""}) else {
            return []
        }
        
        return coverURLs
    }
    
    var imageURLs: [String] {
        guard let artworks = self.artworks,
              let screenshots = self.screenshots,
              let cover = self.cover,
              let url = cover.url else {
            return []
        }
        
        let coverUrl = [url]
        let artworkURLs = artworks.compactMap({$0.url})
        let screenshotURLs = screenshots.compactMap({$0.url})
        
        return coverUrl + artworkURLs + screenshotURLs
    }
    
    var screenshotURLs: [String] {
        var urls = [String]()
        guard let videos = self.screenshots?.compactMap({$0.url ?? ""}) else {
            return []
        }
        
        for url in videos {
            urls.append(url)
        }
        return urls
    }
    
    var videoURLs: [String] {
        var urls = [String]()
        guard let videos = self.videos?.compactMap({$0.videoID ?? ""}) else {
            return []
        }
        
        for url in videos {
            urls.append(url)
        }
        return urls
    }
    
    var platformsText: String {
        guard let platforms else {
            return "N/A"
        }
        
        return platforms.compactMap({$0.name}).joined(separator: ", ")
    }
    
    var genreText: String {
        guard let genres else {
            return "N/A"
        }
        
        return genres.compactMap({$0.name}).joined(separator: ", ")
    }
    
    var ratingText: String {
        guard let rating = self.totalRating else {
            return Rating.NotReviewed.rawValue
        }
        
        switch Int(rating) {
        case 0...40:
            return Rating.Skip.rawValue
        case 40...50:
            return Rating.Meh.rawValue
        case 50...80:
            return Rating.Good.rawValue
        case 80...100:
            return Rating.Exceptional.rawValue
        default:
            return Rating.NotReviewed.rawValue
        }
    }
    
    var ratingColor: Color {
        guard let rating = self.totalRating else {
            return Color.gray
        }
        switch Int(rating) {
        case 0...40:
            return Color.red
        case 40...50:
            return Color.orange
        case 50...80:
            return Color.blue
        case 80...100:
            return Color.green
        default:
            return Color.gray
        }
    }
    
    var ratingImage: Image {
        guard let rating = self.totalRating else {
            return Image(systemName: "dot.squareshape.fill")
        }
        switch Int(rating) {
        case 0...40:
            return Image(systemName: "arrowtriangle.down.square.fill")
        case 40...50:
            return Image(systemName: "minus.square.fill")
        case 50...80:
            return Image(systemName: "arrowtriangle.up.square")
        case 80...100:
            return Image(systemName: "star.square.fill")
        default:
            return Image(systemName: "dot.squareshape.fill")
        }
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
    let id: Int?
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
    
    var platform: PopularPlatform? {
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


enum Rating: String, CaseIterable {
    case Exceptional
    case Good
    case Meh
    case Skip
    case NotReviewed = "No Feedback"
}

extension Game {
    
    static var MockGame = Game(
        id: 1,
        cover: Cover(game: 1, url: "https://example.com/cover1.png"),
        firstReleaseDate: 1609459200,
        genres: [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Adventure")],
        name: "Example Game 1",
        platforms: [Platform(id: 1, abbreviation: "PS5", name: "PlayStation 5", platformLogo: 1, summary: "Example summary for PS5")],
        releaseDates: [ReleaseDate(id: 1, date: 1609459200, game: 1, human: "2021-Dec-31", platform: 1)],
        screenshots: [Cover(game: 1, url: "https://example.com/screenshot1.png")],
        summary: "This is an example summary for Example Game 1.",
        totalRating: 85.0, 
        versionTitle: "Gold Edition",
        ratingCount: 100,
        gameModes: [GameMode(id: 1, name: "Single player", url: "https://example.com/single-player")],
        videos: [],
        websites: [],
        similarGames: [],
        artworks: []
    )
}
