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
    
    func deleteFromAll(game: Game, in games: [SavedGame], context: ModelContext) {
        if let gameToDelete = games.first(where: { $0.game?.id == game.id }) {
            context.delete(gameToDelete)
        }
    }
    
    func delete(game: Game, in games: [SavedGame], for library: Library, context: ModelContext) {
        if let gameToDelete = games.first(where: { $0.game?.id == game.id && $0.library == library }) {
            context.delete(gameToDelete)
        }
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
    
    func saveGameTo(game: Game, games: [SavedGame], library: Library, context: ModelContext) {
        guard savedAlreadyLibrarySpecific(game, for: library, games: games) else {
            
            deleteFromAll(game: game, in: games, context: context)
            add(game: game, library: library, context: context)
            
            return
        }
        
        
        delete(game: game, in: games, for: library, context: context)
    }
    
    // MARK: - Delete library
    
    func delete(library: Library, in context: ModelContext) {
        context.delete(library)
    }
}
