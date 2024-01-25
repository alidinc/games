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
    
    @Environment(\.dismiss) var dismiss
    
    @State private var preferences = Admin()
    @State private var gamesViewModel = GamesViewModel()
    
    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                IntroView()
                    .preferredColorScheme(.dark)
            } else {
                UIKitTabView([
                    UIKitTabView.Tab(view: GamesView(vm: gamesViewModel), barItem: UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller.fill"), tag: 0)),
                    UIKitTabView.Tab(view: NewsView(), barItem: UITabBarItem(title: "News", image: UIImage(systemName: "newspaper.fill"), tag: 1)),
                    UIKitTabView.Tab(view: MoreView(), barItem: UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis.circle.fill"), tag: 1)),
                ])
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
