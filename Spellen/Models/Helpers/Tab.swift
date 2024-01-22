//
//  Tab.swift
//  Spellen
//
//  Created by alidinc on 22/01/2024.
//

import SwiftUI

enum Tab: String {
    case discover = "Games"
    case more = "More"
    case news = "News"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .discover:
            Image(systemName: "gamecontroller.fill")
            Text(self.rawValue)
        case .more:
            Image(systemName: "ellipsis.circle.fill")
            Text(self.rawValue)
        case .news:
            Image(systemName: "newspaper.fill")
            Text(self.rawValue)
        }
    }
}
