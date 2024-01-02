//
//  LibraryType.swift
//  Gametrack
//
//  Created by Ali Dinç on 02/01/2024.
//

import Foundation
import SwiftUI

enum LibraryType: Int, CaseIterable, Hashable {
    case wishlist = 0
    case purchased = 1
    case owned = 2
    case played = 3
    
    var id: Int {
        switch self {
        default:
            return self.rawValue
        }
    }
    
    var title: String {
        switch self {
        case .wishlist:
            return "Wishlist"
        case .purchased:
            return "Purchased"
        case .owned:
            return "Owned"
        case .played:
            return "Played"
        }
    }
    
    var iconName: String {
        switch self {
        case .wishlist:
            return "heart"
        case .purchased:
            return "bag"
        case .owned:
            return "bookmark"
        case .played:
            return "checkmark.square"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .wishlist:
            return "heart.fill"
        case .purchased:
            return "bag.fill"
        case .owned:
            return "bookmark.fill"
        case .played:
            return "checkmark.square.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .wishlist:
            return Color.pink
        case .purchased:
            return Color.orange
        case .owned:
            return Color.blue
        case .played:
            return Color.green
        }
    }
}
