//
//  SavedGame.swift
//  JustGames
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftData
import SwiftUI

// MARK: - Game
@Model
class SavedGame: Identifiable, Hashable {
    
    var date: Date
    var library: Int
    
    @Attribute(.externalStorage)
    var gameData: Data?
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
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
    
    init(date: Date = .now, library: Int) {
        self.date = date
        self.library = library
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
