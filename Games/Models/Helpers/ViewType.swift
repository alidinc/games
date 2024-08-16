//
//  ViewType.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import Foundation

enum ViewType: String, CaseIterable, RawRepresentable, Identifiable {
    case list
    case grid
    
    var imageName: String {
        switch self {
        case .list:
            return "rectangle.grid.1x2.fill"
        case .grid:
            return "rectangle.grid.3x2.fill"
        }
    }
    
    var id: String {
        switch self {
        default:
           return UUID().uuidString
        }
    }
}
