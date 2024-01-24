//
//  SavedNews.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import Foundation
import SwiftData

// MARK: - SavedNews
@Model
class SavedNews {
    
    var title: String = ""
    var icon: String = "bookmark.fill"
    var savingId: String?
    
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
