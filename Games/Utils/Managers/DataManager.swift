//
//  SwiftDataManager.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI
import Observation
import SwiftData

@Observable
class DataManager {

    private var bag = Bag()

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
    
    func add(game: Game, for library: Library) -> SavedGame {
        let savedGame = SavedGame()
        savedGame.library = library
        
        getImageData(game: game) { data in
            if let data {
                savedGame.imageData = data
            }
        }
        
        savedGame.gameData = self.getGameData(game: game)
        return savedGame
    }
}
