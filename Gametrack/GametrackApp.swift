//
//  CardsApp.swift
//  Cards
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

@main
struct GametrackApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .modelContainer(for: [SavedGame.self])
        }
    }
}
