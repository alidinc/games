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
    
    var id: String
    var date: Date
    var library: Int
    
    @Attribute(.externalStorage)
    var gameData: Data?
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
    @Transient
    var libraryType: LibraryType {
        get {
            return LibraryType(rawValue: Int(library)) ?? .wishlist
        }
        
        set {
            self.library = Int(newValue.rawValue)
        }
    }
    
    @Transient
    var game: Game? {
        do {
            guard let gameData = self.gameData else {
                return nil
            }
            return try JSONDecoder().decode(Game.self, from: gameData)
        } catch {
            return nil
        }
    }
    
    init(id: String = UUID().uuidString, date: Date = .now, library: Int, gameData: Data? = nil) {
        self.id = id
        self.date = date
        self.library = library
        self.gameData = gameData
    }
    
    func containsPopularPlatforms(_ popularPlatforms: [PopularPlatform]) -> Bool {
        guard let game, let gamePlatforms = game.platforms else {
            return false
        }
        
        let gamePlatformSet = Set(gamePlatforms.map { $0.popularPlatform })
        let popularPlatformSet = Set(popularPlatforms)
        
        return popularPlatformSet.isSubset(of: gamePlatformSet)
    }
    
    func containsPopularGenres(_ popularGenres: [PopularGenre]) -> Bool {
        guard let game, let gameGenres = game.genres else {
            return false
        }
        
        let gameGenreSet = Set(gameGenres.map { $0.popularGenre })
        let popularGenreSet = Set(popularGenres)
        
        return popularGenreSet.isSubset(of: gameGenreSet)
    }
}
