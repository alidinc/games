//
//  SavingViewModel.swift
//  JustGames
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI
import Observation
import SwiftData

@Observable
class SavingViewModel {
    
    private var bag = Bag()
    
    func add(game: Game, library: Library, context: ModelContext) {
        let savedGame = SavedGame()
        savedGame.library = library
        
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
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Downloaded")
                    case .failure(_):
                        print("Failed to download")
                    }
                } receiveValue: { data in
                    savedGame.imageData = data
                }
                .store(in: &bag)
        }
       
        context.insert(savedGame)
    }
    
    func delete(game: Game, in games: [SavedGame], context: ModelContext) {
        if let gameToDelete = games.first(where: { $0.game?.id == game.id }) {
            context.delete(gameToDelete)
        }
    }
    
    // MARK: - Save to "All games" first
    
    func savedAlreadyInAll(game: Game, libraries: [Library]) -> Bool {
        if let allSavedGamesLibrary = libraries.first(where: { $0.savingId == Constants.allGamesLibraryID }) {
            return allSavedGamesLibrary.savedGames?.first(where: { $0.game?.id == game.id }) != nil
        }
        
        return false
    }
    
    func saveToAllFirst(game: Game, games: [SavedGame], libraries: [Library], context: ModelContext) {
        guard self.savedAlreadyInAll(game: game, libraries: libraries) else {
            delete(game: game, in: games, context: context)
            
            if let library = libraries.first(where: { $0.savingId == Constants.allGamesLibraryID }) {
                add(game: game, library: library, context: context)
            }
            
            return
        }
        
        delete(game: game, in: games, context: context)
    }
    
    // MARK: - Saved already -not library specific
    
    func savedAlready(game: Game, games: [SavedGame]) -> Bool {
        return games.first(where: { $0.game?.id == game.id }) != nil
    }
    
    // MARK: - Save to "library" specific
    
    func savedAlreadyLibrarySpecific(_ game: Game, for library: Library, games: [SavedGame]) -> Bool {
        games.first { savedGame in
            guard let id = game.id,
                  let savedGameGame = savedGame.game,
                  let savedGameId = savedGameGame.id,
                  let savedGameLibrary = savedGame.library else {
                return false
            }
            
            return savedGameId == id && savedGameLibrary == library
        } != nil
    }
    
    func saveGameTo(game: Game, games: [SavedGame], library: Library, libraries: [Library], context: ModelContext) {
        guard library.savedGames?.first(where: { $0.game?.id == game.id }) != nil else {
            delete(game: game, in: games, context: context)
            
            add(game: game, library: library, context: context)
            
            return
        }
        
        delete(game: game, in: games, context: context)
        saveToAllFirst(game: game, games: games, libraries: libraries, context: context)
    }
}
