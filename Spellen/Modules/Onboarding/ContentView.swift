//
//  ContentView.swift
//  Spellen
//
//  Created by alidinc on 22/01/2024.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    @State private var activeTab: Tab = .discover
    @State private var preferences = Admin()
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
        .environment(gamesViewModel)
    }
}
