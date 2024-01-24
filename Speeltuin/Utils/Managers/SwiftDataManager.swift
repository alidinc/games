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
    var library: Library?
    
    var fetchSavedGames: [SavedGame] {
        do {
            return try modelContext.fetch(FetchDescriptor<SavedGame>())
        } catch {
            return []
        }
    }
    
    func setLibrary(library: Library) {
        self.library = library
    }
    
    // MARK: - SavedGame
    
    func add(game: Game) {
        let savedGame = SavedGame()
        
        if let library {
            savedGame.library = library
        }
        
        do {
            savedGame.gameData = try JSONEncoder().encode(game)
        } catch {
            print("Error")
        }
        
        if let cover = game.cover,
           let urlString = cover.url,
           let url = URL(string: "https:\(urlString.replacingOccurrences(of: "t_thumb", with: "t_1080p"))") {
            
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
    
    func deleteFromAll(game: Game) {
        if let gameToDelete = fetchSavedGames.first(where: { $0.game?.id == game.id }) {
            modelContext.delete(gameToDelete)
        }
    }
    
    // MARK: - Toggle
    
    func savedAlreadyLibrarySpecific(_ game: Game) -> Bool {
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
    
    func toggle(game: Game) {
        guard savedAlreadyLibrarySpecific(game) else {
            
            deleteFromAll(game: game)
            add(game: game)
            
            if let library {
                NotificationCenter.default.post(name: .addedToLibrary, object: library)
            }
            
            return
        }
        
        deleteFromAll(game: game)
    }
}
