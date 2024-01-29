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
    
    @Relationship(deleteRule: .cascade, inverse: \SwiftGame.library)
    var savedGames: [SwiftGame]? = []
    
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
