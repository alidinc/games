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
    
    var imageData: Data?
    
    func delete(game: Game, in games: [SavedGame], context: ModelContext) {
        if let gameToDelete = games.first(where: { $0.game?.id == game.id }) {
            context.delete(gameToDelete)
        }
    }
    
    func add(game: Game, for library: LibraryType, context: ModelContext) {
        let savedGame = SavedGame(library: library.id)
        
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
    
    func alreadyExists(_ game: Game, games: [SavedGame], in library: LibraryType) -> Bool {
        return ((games.first(where: {$0.game?.id == game.id && $0.library == library.id })) != nil)
    }
    
    func handleToggle(game: Game, library: LibraryType, games: [SavedGame], context: ModelContext) {
        guard self.alreadyExists(game, games: games, in: library) else {
            delete(game: game, in: games, context: context)
            add(game: game, for: library, context: context)
            return
        }
        
        delete(game: game, in: games, context: context)
    }
}
