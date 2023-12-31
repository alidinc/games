//
//  SavedGame.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
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
        artworks: [Artwork]?
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
    }
    
    @Relationship(deleteRule: .nullify)
    var games: [Library] = []
}
