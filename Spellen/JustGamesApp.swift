//
//  JustGames.swift
//  JustGames
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

@main
struct SpellenApp: App {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                IntroView()
                    .preferredColorScheme(.dark)
            } else {
                ContentView()
                    .preferredColorScheme(.dark)
            }
        }
        .modelContainer(for: [Library.self, SavedGame.self])
    }
}
