//
//  GameDetailView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct DetailView: View {
    
    var game: Game?
    var savedGame: SavedGame?
    
    @Environment(Preferences.self) private var preferences
    
    init(game: Game? = nil, savedGame: SavedGame? = nil) {
        self.savedGame = savedGame
        self.game = game
    }
    
    var body: some View {
        switch preferences.networkStatus {
        case .local:
            if let savedGame {
                SavedGameDetailView(savedGame: savedGame)
            }
        case .network:
            if let game {
                GameDetailView(game: game)
            }
        }
    }
}
