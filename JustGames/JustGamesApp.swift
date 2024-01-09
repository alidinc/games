//
//  JustGames.swift
//  JustGames
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

@main
struct JustGamesApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .modelContainer(for: [SavedGame.self])
        }
    }
}
