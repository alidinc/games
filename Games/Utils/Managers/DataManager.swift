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
actor DataManager {
    
    private var bag = Bag()
    
    init(container: ModelContainer) {
        modelContainer = container
        modelExecutor = DefaultSerialModelExecutor(modelContext: ModelContext(container))
    }
    
    var fetchSavedGames: [SavedGame] {
        do {
            return try modelContext.fetch(FetchDescriptor<SavedGame>())
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
    
    func getGameData(game: Game) -> Data? {
        do {
            return try JSONEncoder().encode(game)
        } catch {
            return nil
        }
    }
    
    func getImageData(game: Game, completion: @escaping (Data?) -> Void) {
        if let cover = game.cover,
           let urlString = cover.url,
           let url = URL(string: "https:\(urlString.replacingOccurrences(of: "t_thumb", with: "t_720p"))") {
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .sink { _ in
                    
                } receiveValue: { data in
                    completion(data)
                }
                .store(in: &bag)
        } else {
            completion(nil)
        }
    }
    
    // MARK: - SavedGame
    
    func add(game: Game, for library: Library) {
        let savedGame = SavedGame()
        savedGame.library = library
        
        getImageData(game: game) { data in
            if let data {
                savedGame.imageData = data
            }
        }
        
        savedGame.gameData = self.getGameData(game: game)
        modelContext.insert(savedGame)
        save()
    }
    
    func delete(game: Game) {
        if let gameToDelete = fetchSavedGames.first(where: { $0.gameId == game.id }) {
            modelContext.delete(gameToDelete)
            save()
        }
    }
    
    func deleteAllLibraries() {
        do {
            try modelContext.delete(model: Library.self)
            save()
        } catch {
            
        }
    }
    
    func addLibrary(library: Library) {
        modelContext.insert(library)
        save()
    }
    
    func addNews(news: SPNews) {
        modelContext.insert(news)
        save()
    }
    
    func deleteNews(news: SPNews) {
        modelContext.delete(news)
        save()
    }
    
    // MARK: - Toggle
    
    func savedAlready(_ game: Game, for library: Library) -> Bool {
        ((library.savedGames?.first(where: { $0.gameId == game.id })) != nil)
    }
    
    func toggle(game: Game, for library: Library) {
        guard savedAlready(game, for: library) else {
            
            delete(game: game)
            add(game: game, for: library)
            
            NotificationCenter.default.post(name: .addedToLibrary, object: library)
            return
        }
    }
}
