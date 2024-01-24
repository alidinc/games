//
//  Speeltuin.swift
//  Speeltuin
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

@main
struct SpeeltuinApp: App {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("appTint") var appTint: Color = .white
    
    @State private var activeTab: Tab = .games
    @State private var preferences = Admin()
    @State private var gamesViewModel = GamesViewModel()
    
    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                IntroView()
                    .preferredColorScheme(.dark)
            } else {
                TabView(selection: $activeTab) {
                    GamesView(vm: gamesViewModel)
                        .tag(Tab.games)
                        .tabItem { Tab.games.tabContent }
                    
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
                .preferredColorScheme(.dark)
            }
        }
        .modelContainer(
            for: [
                Library.self,
                SavedGame.self,
                SavedNews.self
            ],
            inMemory: false
        )
    }
}
