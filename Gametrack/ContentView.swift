//
//  ContentView.swift
//  Cards
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
    @State private var discoverViewModel = DiscoverViewModel()
    @State private var libraryViewModel = LibraryViewModel()
    
    var body: some View {
        TabView(selection: $activeTab) {
            DiscoverView(vm: discoverViewModel)
                .tag(Tab.discover)
                .tabItem { Tab.discover.tabContent }
            
            LibraryView(vm: libraryViewModel)
                .tag(Tab.library)
                .tabItem { Tab.library.tabContent }
            
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
        .environment(discoverViewModel)
        .environment(libraryViewModel)
    }
}

#Preview {
    ContentView()
}


enum Tab: String {
    case discover = "Discover"
    case library = "Library"
    case more = "More"
    case news = "News"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .discover:
            Image(systemName: "network")
            Text(self.rawValue)
        case .library:
            Image(systemName: "bookmark")
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
