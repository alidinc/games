//
//  NewsType.swift
//  JustGames
//
//  Created by Ali Dinç on 08/01/2024.
//

import Foundation

enum NewsType: String, CaseIterable {
    
    case ign
    case nintendo
    case xbox
    
    
    var id: String {
        switch self {
        default :
            return UUID().uuidString
        }
    }
    
    var title: String {
        switch self {
        case .ign:
            return "IGN"
        case .nintendo:
            return "Nintendo Life"
        case .xbox:
            return "Pure Xbox"
        }
    }
    
    var urlString: String {
        switch self {
        case .ign:
            return "https://www.ign.com/rss/articles/feed?tags=games&count=50"
        case .nintendo:
            return "https://www.nintendolife.com/feeds/news"
        case .xbox:
            return "https://www.purexbox.com/feeds/news"
        }
    }
}
