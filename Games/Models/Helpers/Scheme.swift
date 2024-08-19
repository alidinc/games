//
//  Scheme.swift
//  Games
//
//  Created by Ali Dinç on 19/08/2024.
//

import Foundation

enum SchemeType: Int, Identifiable, CaseIterable {
    var id: Self { self }
    case system
    case light
    case dark


    var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }

    var imageName: String {
        switch self {
        case .system:
            return "moon.fill"
        case .light:
            return "circle.lefthalf.filled.righthalf.striped.horizontal"
        case .dark:
            return "circle.lefthalf.filled.righthalf.striped.horizontal.inverse"
        }
    }
}
