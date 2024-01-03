//
//  CardsApp.swift
//  Cards
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

@main
struct GametrackApp: App {
    
    @State private var preferences = Preferences()
    @State private var saving = SavingViewModel()
    @State private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environment(preferences)
                .environment(saving)
                .environment(networkMonitor)
        }
        .modelContainer(for: [SavedGame.self])
    }
}
