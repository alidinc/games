//
//  LibraryType.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import Foundation
import SwiftUI

enum LibraryType: Int, CaseIterable, Hashable {
    case all = 0
    case wishlist = 1
    case purchased = 2
    case played = 3
    
    var id: Int {
        switch self {
        default:
            return self.rawValue
        }
    }
    
    var searchTitle: String {
        switch self {
        case .all:
            return "Search in your whole library"
        default:
            return "Search in your \(self.title)"
        }
    }
    
    var title: String {
        switch self {
        case .wishlist:
            return "Wishlist"
        case .purchased:
            return "Purchased"
        case .played:
            return "Played"
        default:
            return "All library"
        }
    }
    
    var imageName: String {
        switch self {
        case .wishlist:
            return "heart"
        case .purchased:
            return "bag"
        case .played:
            return "checkmark.square"
        default:
            return "gamecontroller"
        }
    }
    
    var selectedImageName: String {
        switch self {
        case .wishlist:
            return "heart.fill"
        case .purchased:
            return "bag.fill"
        case .played:
            return "checkmark.square.fill"
        default:
            return "gamecontroller.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .wishlist:
            return Color.pink
        case .purchased:
            return Color.orange
        case .played:
            return Color.green
        default:
            return Color.white
        }
    }
}
