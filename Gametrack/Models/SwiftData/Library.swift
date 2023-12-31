//
//  Library.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI

@Model
class Library: Identifiable {
    var id: String
    var name: String
    
    @Relationship(deleteRule: .cascade)
    var games: [SavedGame]
    
    init(id: String = UUID().uuidString, name: String, games: [SavedGame] = []) {
        self.id = id
        self.name = name
        self.games = games
    }
}

