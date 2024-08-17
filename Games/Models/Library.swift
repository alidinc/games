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
    var subtitle: String?
    var date: Date = Date.now

    var id: String { return UUID().uuidString }

    @Attribute(.externalStorage)
    var imageData: Data?

    @Relationship(deleteRule: .cascade, inverse: \SavedGame.library)
    var savedGames: [SavedGame]? = []
    
    init(title: String = "", subtitle: String?, imageData: Data?) {
        self.title = title
        self.subtitle = subtitle
        self.imageData = imageData
    }
}
