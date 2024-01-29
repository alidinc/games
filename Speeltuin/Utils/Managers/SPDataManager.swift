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
actor SPDataManager {
    
    private var bag = Bag()
    
    init(container: ModelContainer) {
        modelContainer = container
        modelExecutor = DefaultSerialModelExecutor(modelContext: ModelContext(container))
    }
    
    var fetchSavedGames: [SPGame] {
        do {
            return try modelContext.fetch(FetchDescriptor<SPGame>())
        } catch {
            return []
        }
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            
        }
    }
    
    // MARK: - SavedGame
    
    func add(game: Game, for library: SPLibrary) {
        let savedGame = SPGame()
        savedGame.library = library
        
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
        
        Task(priority: .background) {
            do {
                savedGame.gameData = try JSONEncoder().encode(game)
            } catch {
                print("Error")
            }
        }
        
        modelContext.insert(savedGame)
        save()
    }
    
    func delete(game: Game) {
        if let gameToDelete = fetchSavedGames.first(where: { $0.game?.id == game.id }) {
            modelContext.delete(gameToDelete)
            save()
        }
    }
    
    func addLibrary(library: SPLibrary) {
        modelContext.insert(library)
        save()
    }
    
    // MARK: - Toggle
    
    private func savedAlready(_ game: Game, for library: SPLibrary) -> Bool {
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
    
    func toggle(game: Game, for library: SPLibrary) {
        guard savedAlready(game, for: library) else {
            
            delete(game: game)
            add(game: game, for: library)
            
            NotificationCenter.default.post(name: .addedToLibrary, object: library)
            return
        }
        
        delete(game: game)
    }
}
