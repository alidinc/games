//
//  GameDetailViewModel.swift
//  JustGames
//
//  Created by Ali Dinç on 24/12/2023.
//

import SwiftUI
import Observation

@Observable
class GameDetailViewModel {
    
    var gamesFromIds: [Game] = []
    
    func fetchGames(from ids: [Int]) async {
        do {
            let response = try await NetworkManager.shared.fetchGames(ids: ids)
            self.gamesFromIds = response
        } catch {
            self.gamesFromIds = []
        }
    }
}
