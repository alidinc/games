//
//  ContentView.swift
//  Cards
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("appTint") var appTint: Color = .purple
    @State private var activeTab: Tab = .home
    
    var body: some View {
        TabView(selection: $activeTab) {
            HomeView()
                .tag(Tab.home)
                .tabItem { Tab.home.tabContent }
            
            Text("")
                .tag(Tab.search)
                .tabItem { Tab.search.tabContent }
            
            Text("")
                .tag(Tab.library)
                .tabItem { Tab.library.tabContent }
            
            SettingsView()
                .tag(Tab.settings)
                .tabItem { Tab.settings.tabContent }
        }
        .tint(appTint)
    }
}

#Preview {
    ContentView()
}


enum Tab: String {
    case home = "Home"
    case search = "Search"
    case library = "Library"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .home:
            Image(systemName: "house")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        case .library:
            Image(systemName: "bookmark.square.fill")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
        }
    }
}
