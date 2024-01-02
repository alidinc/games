//
//  SavingViewModel.swift
//  Gametrack
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI
import Observation
import SwiftData

@Observable
class SavingViewModel {
    
    private var bag = Bag()
    
    func alreadyExists(_ game: Game, games: [SavedGame], in library: LibraryType) -> Bool {
        return ((games.first(where: {$0.id == game.id && $0.libraryType == library.id })) != nil)
    }
    
    func handleToggle(game: Game, library: LibraryType, games: [SavedGame], context: ModelContext) {
        guard self.alreadyExists(game, games: games, in: library) else {
            delete(game: game, in: games, context: context)
            add(game: game, for: library, context: context)
            return
        }
        
        delete(game: game, in: games, context: context)
    }
    
    func delete(game: Game, in games: [SavedGame], context: ModelContext) {
        if let gameToDelete = games.first(where: { $0.id == game.id }) {
            context.delete(gameToDelete)
        }
    }
    
    func add(game: Game, for library: LibraryType, context: ModelContext) {
        let savedGame = SavedGame(
            id: game.id,
            name: game.name,
            cover: game.cover,
            firstReleaseDate: game.firstReleaseDate,
            summary: game.summary,
            totalRating: game.totalRating,
            ratingCount: game.ratingCount,
            genres: game.genres,
            platforms: game.platforms,
            releaseDates: game.releaseDates,
            screenshots: game.screenshots,
            gameModes: game.gameModes,
            videos: game.videos,
            websites: game.websites,
            similarGames: game.similarGames,
            artworks: game.artworks,
            libraryType: library.id
        )
        
        imageData(game: game) { data in
            if let data {
                savedGame.imageData = data
            }
        }
        
        context.insert(savedGame)
    }
    
    func imageData(game: Game, completion: @escaping (Data?) -> Void) {
        if let cover = game.cover,
           let urlString = cover.url,
           let url = URL(string: "https:\(urlString.replacingOccurrences(of: "t_thumb", with: "t_1080p"))") {
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Downloaded")
                    case .failure(_):
                        print("Failed to download")
                    }
                } receiveValue: { data in
                    completion(data)
                }
                .store(in: &bag)
        } else {
            completion(nil)
        }
    }
}


extension ModelContext {
  func existingModel<T>(for objectID: PersistentIdentifier)
    throws -> T? where T: PersistentModel {
    if let registered: T = registeredModel(for: objectID) {
        return registered
    }
        
    let fetchDescriptor = FetchDescriptor<T>(
        predicate: #Predicate {
        $0.persistentModelID == objectID
    })
    
    return try fetch(fetchDescriptor).first
  }
}
