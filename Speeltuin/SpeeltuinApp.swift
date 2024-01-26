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
    @AppStorage("appTint")     private var appTint: Color = .blue
    @AppStorage("colorScheme") private var scheme: SchemeType = .system
    
    @Environment(\.dismiss) var dismiss
    
    @State private var preferences = Admin()
    @State private var gamesViewModel = GamesViewModel()
    
    @State private var activeTab: Tab = .games
    
    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                IntroView()
                    .preferredColorScheme(.dark)
            } else {
                NavigableTabView {
                    NavigableTabViewItem(tabSelection: .games, imageName: "gamecontroller.fill") {
                        GamesTab(vm: gamesViewModel)
                    }
                    
                    NavigableTabViewItem(tabSelection: .news, imageName: "newspaper.fill") {
                        NewsTab()
                    }
                    
                    NavigableTabViewItem(tabSelection: .more, imageName: "ellipsis.circle.fill") {
                        MoreTab()
                    }
                }
                .tint(appTint)
                .environment(preferences)
                .environment(gamesViewModel)
                .preferredColorScheme(setColorScheme())
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
    
    func setColorScheme() -> ColorScheme? {
        switch self.scheme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

var didRemoteChange = NotificationCenter
    .default
    .publisher(for: .NSPersistentStoreRemoteChange)
    .receive(on: RunLoop.main)
