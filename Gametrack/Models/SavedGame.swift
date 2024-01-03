//
//  SavedGame.swift
//  Gametrack
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftData
import SwiftUI

// MARK: - Game
@Model
class SavedGame: Identifiable, Hashable {
    
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
    
    var libraryType: Int
    
    @Attribute(.externalStorage)
    var imageData: Data?

    init(
        id: Int?,
        name: String?,
        cover: Cover?,
        firstReleaseDate: Int?,
        summary: String?,
        totalRating: Double?,
        ratingCount: Int?,
        genres: [Genre]?,
        platforms: [Platform]?,
        releaseDates: [ReleaseDate]?,
        screenshots: [Cover]?,
        gameModes: [GameMode]?,
        videos: [Video]?,
        websites: [Website]?,
        similarGames: [Int]?,
        artworks: [Artwork]?,
        libraryType: Int
    ) {
        self.id = id
        self.name = name
        self.cover = cover
        self.firstReleaseDate = firstReleaseDate
        self.summary = summary
        self.totalRating = totalRating
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
        self.libraryType = libraryType
    }
    
    convenience init(from game: Game, library: LibraryType) {
        self.init(
            id: game.id,
            name: game.name,
            cover: game.cover,
            firstReleaseDate: game.firstReleaseDate,
            summary: game.summary,
            totalRating: game.totalRating,
            ratingCount: game.ratingCount,
            genres: game.genres,
            platforms: game.platforms,
            releaseDates: game.releaseDates,
            screenshots: game.screenshots,
            gameModes: game.gameModes,
            videos: game.videos,
            websites: game.websites,
            similarGames: game.similarGames,
            artworks: game.artworks,
            libraryType: library.id
        )
    }
}
