//
//  ViewType.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import Foundation

enum ViewType: String, CaseIterable {
    case list
    case grid
    case card
    
    var imageName: String {
        switch self {
        case .list:
            return "rectangle.grid.1x2.fill"
        case .grid:
            return "rectangle.grid.3x2.fill"
        case .card:
            return "list.bullet.rectangle.portrait.fill"
        }
    }
}
