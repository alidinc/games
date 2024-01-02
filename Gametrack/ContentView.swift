//
//  ContentView.swift
//  Cards
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    @State private var activeTab: Tab = .home
    
    var body: some View {
        TabView(selection: $activeTab) {
            HomeView()
                .tag(Tab.home)
                .tabItem { Tab.home.tabContent }
            
           LibraryView()
                .tag(Tab.library)
                .tabItem { Tab.library.tabContent }
            
            MoreView()
                .tag(Tab.more)
                .tabItem { Tab.more.tabContent }
        }
        .tint(appTint)
    }
}

#Preview {
    ContentView()
}


enum Tab: String {
    case home = "Home"
    case library = "Library"
    case more = "More"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .home:
            Image(systemName: "house")
            Text(self.rawValue)
        case .library:
            Image(systemName: "bookmark.square.fill")
            Text(self.rawValue)
        case .more:
            Image(systemName: "ellipsis.circle.fill")
            Text(self.rawValue)
        }
    }
}
