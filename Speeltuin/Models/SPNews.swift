//
//  SPNews.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import Foundation
import SwiftData

// MARK: - SavedNews
@Model
class SPNews {
    
    var title: String = ""
    var savingId: String?
    var link: String?
    var details: String?
    var pubDate: Date?
    
    init(
        id: String = UUID().uuidString,
        title: String = "",
        link: String,
        details: String,
        pubDate: Date
    ) {
        self.savingId = id
        self.title = title
        self.link = link
        self.details = details
        self.pubDate = pubDate
    }
}

extension SPNews {
    
    var dateString: String {
        self.pubDate?.asString(style: .medium) ?? ""
    }
}
