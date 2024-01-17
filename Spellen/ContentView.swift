//
//  ContentView.swift
//  JustGames
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    @State private var activeTab: Tab = .discover
    
    @State private var preferences = Preferences()
    @State private var saving = SavingViewModel()
    @State private var networkMonitor = NetworkMonitor()
    @State private var gamesViewModel = GamesViewModel()
    
    var body: some View {
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
        .environment(saving)
        .environment(networkMonitor)
        .environment(gamesViewModel)
    }
}

#Preview {
    ContentView()
}


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
