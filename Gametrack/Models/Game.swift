//
//  Game.swift
//  A-games
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftData
import SwiftUI

// MARK: - Game
@Model
class Game: Codable, Identifiable, Hashable {
    
    let id: Int?
    let name: String?
    let cover: Cover?
    let firstReleaseDate: Int?
    let summary: String?
    let totalRating: Double?
    let versionTitle: String?
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
        case versionTitle = "version_title"
        case similarGames = "similar_games"
    }
    
    init(
        id: Int?,
        name: String?,
        cover: Cover?,
        firstReleaseDate: Int?,
        summary: String?,
        totalRating: Double?,
        versionTitle: String?,
        ratingCount: Int?,
        genres: [Genre]?,
        platforms: [Platform]?,
        releaseDates: [ReleaseDate]?,
        screenshots: [Cover]?,
        gameModes: [GameMode]?,
        videos: [Video]?,
        websites: [Website]?,
        similarGames: [Int]?,
        artworks: [Artwork]?
    ) {
        self.id = id
        self.name = name
        self.cover = cover
        self.firstReleaseDate = firstReleaseDate
        self.summary = summary
        self.totalRating = totalRating
        self.versionTitle = versionTitle
        self.ratingCount = ratingCount
        self.genres = genres
        self.platforms = platforms
        self.releaseDates = releaseDates
        self.screenshots = screenshots
        self.gameModes = gameModes
        self.videos = videos
        self.websites = websites
        self.similarGames = similarGames
        self.artworks = artworks
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.cover = try container.decode(Cover.self, forKey: .cover)
        self.artworks = try container.decode([Artwork].self, forKey: .artworks)
        self.firstReleaseDate = try container.decode(Int.self, forKey: .firstReleaseDate)
        self.genres = try container.decode([Genre].self, forKey: .genres)
        self.name = try container.decode(String.self, forKey: .name)
        self.platforms = try container.decode([Platform].self, forKey: .platforms)
        self.releaseDates = try container.decode([ReleaseDate].self, forKey: .releaseDates)
        self.screenshots = try container.decode([Cover].self, forKey: .screenshots)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.totalRating = try container.decode(Double.self, forKey: .totalRating)
        self.ratingCount = try container.decode(Int.self, forKey: .ratingCount)
        self.gameModes = try container.decode([GameMode].self, forKey: .gameModes)
        self.videos = try container.decode([Video].self, forKey: .videos)
        self.websites = try container.decode([Website].self, forKey: .websites)
        self.versionTitle = try container.decode(String.self, forKey: .versionTitle)
        self.similarGames = try container.decode([Int].self, forKey: .similarGames)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(cover, forKey: .cover)
        try container.encode(artworks, forKey: .artworks)
        try container.encode(firstReleaseDate, forKey: .firstReleaseDate)
        try container.encode(genres, forKey: .genres)
        try container.encode(name, forKey: .name)
        try container.encode(platforms, forKey: .platforms)
        try container.encode(releaseDates, forKey: .releaseDates)
        try container.encode(screenshots, forKey: .screenshots)
        try container.encode(summary, forKey: .summary)
        try container.encode(totalRating, forKey: .totalRating)
        try container.encode(ratingCount, forKey: .ratingCount)
        try container.encode(gameModes, forKey: .gameModes)
        try container.encode(videos, forKey: .videos)
        try container.encode(websites, forKey: .websites)
        try container.encode(versionTitle, forKey: .versionTitle)
        try container.encode(similarGames, forKey: .similarGames)
    }
}

// MARK: - Artwork
@Model
class Artwork: Codable, Hashable {
    let id: Int?
    let url: String?
    
    enum CodingKeys: CodingKey {
        case id
        case url
    }
    
    init(id: Int?, url: String?) {
        self.id = id
        self.url = url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
    }
}

// MARK: - Cover
@Model
class Cover: Codable, Hashable {
    let id: Int?
    let url: String?
    
    enum CodingKeys: CodingKey {
        case id
        case url
    }
    
    init(id: Int?, url: String?) {
        self.id = id
        self.url = url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
    }
}

// MARK: - GameMode
@Model
class GameMode: Codable, Hashable {
    let id: Int?
    let name: String?
    let url: String?
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case url
    }
    
    init(id: Int?, name: String?, url: String?) {
        self.id = id
        self.name = name
        self.url = url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
    }
}

// MARK: - Genre
@Model
class Genre: Codable, Hashable {
    let id: Int?
    let name: String?
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

// MARK: - Platform
@Model
class Platform: Codable, Hashable {
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

    @Transient
    var popularPlatform: PopularPlatform? {
        guard let id = self.id,
              let platform = PopularPlatform(rawValue: id) else {
            return nil
        }
        
        return platform
    }
    
    init(id: Int?, abbreviation: String?, name: String?, platformLogo: Int?, summary: String?) {
        self.id = id
        self.abbreviation = abbreviation
        self.name = name
        self.platformLogo = platformLogo
        self.summary = summary
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.abbreviation = try container.decode(String.self, forKey: .abbreviation)
        self.name = try container.decode(String.self, forKey: .name)
        self.platformLogo = try container.decode(Int.self, forKey: .platformLogo)
        self.summary = try container.decode(String.self, forKey: .summary)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(abbreviation, forKey: .abbreviation)
        try container.encode(platformLogo, forKey: .platformLogo)
        try container.encode(summary, forKey: .summary)
    }
}

// MARK: - ReleaseDate
@Model
class ReleaseDate: Codable, Hashable, Comparable {
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
    
    init(id: Int?, date: Int?, game: Int?, human: String?, platform: Int?) {
        self.id = id
        self.date = date
        self.game = game
        self.human = human
        self.platform = platform
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.date = try container.decode(Int.self, forKey: .date)
        self.game = try container.decode(Int.self, forKey: .game)
        self.human = try container.decode(String.self, forKey: .human)
        self.platform = try container.decode(Int.self, forKey: .platform)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(game, forKey: .game)
        try container.encode(human, forKey: .human)
        try container.encode(platform, forKey: .platform)
    }
}

// MARK: - Video
@Model
class Video: Codable, Hashable {
    let id: Int?
    let videoID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case videoID = "video_id"
    }
    
    init(id: Int?, videoID: String?) {
        self.id = id
        self.videoID = videoID
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.videoID = try container.decode(String.self, forKey: .videoID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(videoID, forKey: .videoID)
    }
}

// MARK: - Website
@Model
class Website: Codable, Hashable {
    let id: Int?
    let category: Int?
    let url: String?
    
    enum CodingKeys: CodingKey {
        case id
        case category
        case url
    }
    
    @Transient
    var platformWebsite: PlatformWebsite? {
        guard let category = self.category,
              let platformWebsite = PlatformWebsite(rawValue: category) else {
            return nil
        }
        
        return platformWebsite
    }
    
    init(id: Int?, category: Int?, url: String?) {
        self.id = id
        self.category = category
        self.url = url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.category = try container.decode(Int.self, forKey: .category)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(category, forKey: .category)
        try container.encode(url, forKey: .url)
    }
}

// MARK: - SimilarGame
@Model
class SimilarGame: Codable, Identifiable, Hashable {
    
    let id: Int?
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
    
    init(
        id: Int?,
        cover: Cover?,
        firstReleaseDate: Int?,
        genres: [Genre]?,
        name: String?,
        platforms: [Platform]?,
        releaseDates: [ReleaseDate]?,
        screenshots: [Cover]?,
        summary: String?,
        totalRating: Double?,
        versionTitle: String?,
        ratingCount: Int?,
        gameModes: [GameMode]?,
        videos: [Video]?,
        websites: [Website]?,
        similarGames: [Int]?,
        artworks: [Artwork]?
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
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.cover = try container.decodeIfPresent(Cover.self, forKey: .cover)
        self.artworks = try container.decodeIfPresent([Artwork].self, forKey: .artworks)
        self.firstReleaseDate = try container.decodeIfPresent(Int.self, forKey: .firstReleaseDate)
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.platforms = try container.decodeIfPresent([Platform].self, forKey: .platforms)
        self.releaseDates = try container.decodeIfPresent([ReleaseDate].self, forKey: .releaseDates)
        self.screenshots = try container.decodeIfPresent([Cover].self, forKey: .screenshots)
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary)
        self.totalRating = try container.decodeIfPresent(Double.self, forKey: .totalRating)
        self.ratingCount = try container.decodeIfPresent(Int.self, forKey: .ratingCount)
        self.gameModes = try container.decodeIfPresent([GameMode].self, forKey: .gameModes)
        self.videos = try container.decodeIfPresent([Video].self, forKey: .videos)
        self.websites = try container.decodeIfPresent([Website].self, forKey: .websites)
        self.versionTitle = try container.decodeIfPresent(String.self, forKey: .versionTitle)
        self.similarGames = try container.decodeIfPresent([Int].self, forKey: .similarGames)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(cover, forKey: .cover)
        try container.encode(artworks, forKey: .artworks)
        try container.encode(firstReleaseDate, forKey: .firstReleaseDate)
        try container.encode(genres, forKey: .genres)
        try container.encode(name, forKey: .name)
        try container.encode(platforms, forKey: .platforms)
        try container.encode(releaseDates, forKey: .releaseDates)
        try container.encode(screenshots, forKey: .screenshots)
        try container.encode(summary, forKey: .summary)
        try container.encode(totalRating, forKey: .totalRating)
        try container.encode(ratingCount, forKey: .ratingCount)
        try container.encode(gameModes, forKey: .gameModes)
        try container.encode(videos, forKey: .videos)
        try container.encode(websites, forKey: .websites)
        try container.encode(versionTitle, forKey: .versionTitle)
        try container.encode(similarGames, forKey: .similarGames)
    }
}
