//
//  Speeltuin.swift
//  Speeltuin
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftData
import SwiftUI

@main
struct SpeeltuinApp: App {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("appTint")     private var appTint: Color = .blue
    @AppStorage("colorScheme") private var scheme: SchemeType = .system
    
    @State private var preferences = Admin()
    @State private var gamesViewModel = GamesViewModel()
    @State private var newsViewModel = NewsViewModel()
    
    private var dataManager: DataManager
    
    var modelContainer: ModelContainer = {
        let schema = Schema([
            SPLibrary.self,
            SPNews.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        self.dataManager = DataManager(container: modelContainer)
    }
    
    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                IntroView()
            } else {
                TabView
            }
        }
        .modelContainer(modelContainer)
    }
    
    private var TabView: some View {
        UIKitTabView([
            UIKitTabView.Tab(view:
                                GamesTab(vm: gamesViewModel, dataManager: dataManager),
                             barItem: UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller.fill"), tag: 0)),
            UIKitTabView.Tab(view:
                                NewsTab(dataManager: dataManager, vm: newsViewModel),
                             barItem: UITabBarItem(title: "News", image: UIImage(systemName: "newspaper.fill"), tag: 1)),
            UIKitTabView.Tab(view:
                                MoreTab(),
                             barItem: UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis.circle.fill"), tag: 1)),
        ])
        .tint(appTint)
        .environment(preferences)
        .environment(gamesViewModel)
        .environment(newsViewModel)
        .preferredColorScheme(setColorScheme())
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
