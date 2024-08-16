//
//  Library.swift
//  Speeltuin
//
//  Created by Ali Dinç on 11/01/2024.
//

import Foundation
import SwiftData

@Model
final class SPLibrary {
    
    var title: String = ""
    var icon: String = "bookmark.fill"
    var savingId: String?
    
    @Relationship(deleteRule: .cascade, inverse: \SPGame.library)
    var savedGames: [SPGame]? = []
    
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
