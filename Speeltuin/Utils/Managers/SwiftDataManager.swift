//
//  SwiftDataManager.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI
import Observation
import SwiftData

@ModelActor
actor SwiftDataManager {
    
    private var bag = Bag()
   
    var fetchSavedGames: [SavedGame] {
        do {
            return try modelContext.fetch(FetchDescriptor<SavedGame>())
        } catch {
            return []
        }
    }
    
    // MARK: - SavedGame
    
    func add(game: Game, for library: Library) {
        let savedGame = SavedGame()
        savedGame.library = library
        
        do {
            savedGame.gameData = try JSONEncoder().encode(game)
        } catch {
            print("Error")
        }
        
        if let cover = game.cover,
           let urlString = cover.url,
           let url = URL(string: "https:\(urlString.replacingOccurrences(of: "t_thumb", with: "t_720p"))") {
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .sink { _ in
                
                } receiveValue: { data in
                    savedGame.imageData = data
                }
                .store(in: &bag)
        }
        
        modelContext.insert(savedGame)
    }
    
    func delete(game: Game) {
        if let gameToDelete = fetchSavedGames.first(where: { $0.game?.id == game.id }) {
            modelContext.delete(gameToDelete)
        }
    }
    
    // MARK: - Toggle
    
    private func savedAlready(_ game: Game, for library: Library) -> Bool {
        fetchSavedGames.first { savedGame in
            guard let id = game.id,
                  let savedGameGame = savedGame.game,
                  let savedGameId = savedGameGame.id,
                  let savedGameLibrary = savedGame.library else {
                return false
            }
            
            return savedGameId == id && savedGameLibrary == library
        } != nil
    }
    
    func toggle(game: Game, for library: Library) {
        guard savedAlready(game, for: library) else {
            
            delete(game: game)
            add(game: game, for: library)
            
            NotificationCenter.default.post(name: .addedToLibrary, object: library)
            return
        }
        
        delete(game: game)
    }
}
