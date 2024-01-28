//
//  Library.swift
//  Speeltuin
//
//  Created by Ali Dinç on 11/01/2024.
//

import Foundation
import SwiftData


@Model
final class Library {
    
    var title: String = ""
    var icon: String = "bookmark.fill"
    var savingId: String?
    
    @Relationship(deleteRule: .cascade, inverse: \SavedGame.library)
    var savedGames: [SavedGame] = []
    
    init(
        id: String = UUID().uuidString,
        title: String = "",
        icon: String = "bookmark.fill",
        savedGames: [SavedGame] = []
    ) {
        self.savingId = id
        self.title = title
        self.icon = icon
        self.savedGames = savedGames
    }
}
