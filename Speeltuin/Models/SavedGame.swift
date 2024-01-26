//
//  SavedGame.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftData
import SwiftUI


@Model
class SavedGame {
    
    var date: Date?
    var library: Library?
    
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
    
    init(date: Date = .now) {
        self.date = date
    }
    
    func containsSelections(_ matchingGenres: [PopularGenre], _ matchingPlatforms: [PopularPlatform]) -> Bool {
        guard let game = self.game,
              let platforms = game.platforms,
              let genres = game.genres   else {
            return false
        }
        
        let matchingPlatforms = matchingPlatforms.filter { platform in
            return platforms.contains(where: { $0.id == platform.id })
        }
        
        let matchingGenres = matchingGenres.filter { genre in
            return genres.contains(where: { $0.id == genre.id })
        }
        
        return !matchingPlatforms.isEmpty || !matchingGenres.isEmpty
    }
    
    func containsGenres(_ matchingGenres: [PopularGenre]) -> Bool {
        guard let game = self.game,
              let genres = game.genres else {
            return false
        }
        
        let matchingGenres = matchingGenres.filter { genre in
            return genres.contains(where: { $0.id == genre.id })
        }
        
        return !matchingGenres.isEmpty
    }
    
    func containsPlatforms(_ matchingPlatforms: [PopularPlatform]) -> Bool {
        guard let game = self.game,
              let platforms = game.platforms else {
            return false
        }
        
        let matchingPlatforms = matchingPlatforms.filter { platform in
            return platforms.contains(where: { $0.id == platform.id })
        }
        
        return !matchingPlatforms.isEmpty
    }
}
