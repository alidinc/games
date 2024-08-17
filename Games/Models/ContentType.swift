//
//  ContentType.swift
//  Games
//
//  Created by Ali Dinç on 17/08/2024.
//

import Foundation

enum ContentType: String, CaseIterable, Identifiable {
    case games
    case news
    case library

    var id: Self { return self }

    var title: String {
        return self.rawValue.capitalized
    }

    var imageName: String {
        switch self {
        case .games:
            return "gamecontroller.fill"
        case .news:
            return "newspaper.fill"
        case .library:
            return "tray.full.fill"
        }
    }
}
