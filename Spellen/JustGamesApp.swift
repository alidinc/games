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
    @AppStorage("appTint") var appTint: Color = .white
    @State private var activeTab: Tab = .discover
    @State private var preferences = Admin()
    @State private var gamesViewModel = GamesViewModel()
    @State private var savingViewModel = SavingViewModel()
    
    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                IntroView()
                    .preferredColorScheme(.dark)
            } else {
                TabView(selection: $activeTab) {
                    GamesView(vm: gamesViewModel)
                        .tag(Tab.discover)
                        .tabItem { Tab.discover.tabContent }
                    
                    NewsView()
                        .tag(Tab.news)
                        .tabItem { Tab.news.tabContent }
                    
                    MoreView()
                        .tag(Tab.more)
                        .tabItem { Tab.more.tabContent }
                }
                .tint(appTint)
                .environment(preferences)
                .environment(gamesViewModel)
                .environment(savingViewModel)
                .preferredColorScheme(.dark)
            }
        }
        .modelContainer(for: [Library.self, SavedGame.self])
    }
}
