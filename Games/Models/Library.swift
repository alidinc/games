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
    var date: Date = Date.now

    var id: String { return UUID().uuidString }

    @Relationship(deleteRule: .cascade, inverse: \SavedGame.library)
    var savedGames: [SavedGame]? = []
    
    init(title: String = "") {
        self.title = title
    }
}
