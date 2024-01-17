//
//  Library.swift
//  JustGames
//
//  Created by Ali Dinç on 11/01/2024.
//

import Foundation
import SwiftData

// MARK: - Game
@Model
class Library {
    
    var title: String = ""
    var icon: String?
    var savingId: String?
    
    @Relationship(deleteRule: .cascade, inverse: \SavedGame.library)
    var savedGames: [SavedGame]?
    
    init(
        id: String = UUID().uuidString,
        title: String = "",
        icon: String = "bookmark.fill"
    ) {
        self.savingId = id
        self.title = title
        self.icon = icon
    }
}
