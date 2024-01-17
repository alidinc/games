//
//  JustGames.swift
//  JustGames
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

@main
struct SpellenApp: App {
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [Library.self, SavedGame.self])
    }
}
