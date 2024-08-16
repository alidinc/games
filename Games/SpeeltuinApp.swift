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

    @State private var showLoadingView = false
    @State private var gameToGoToDetailView: Game?

    private var modelContainer: ModelContainer = {
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

    }

    var body: some Scene {
        WindowGroup {
            TabView
                .opacity(isFirstTime ? 0 : 1)
                .fullScreenCover(isPresented: $isFirstTime, content: { IntroView() })
        }
        .modelContainer(modelContainer)
    }

    private var TabView: some View {
        MainView(vm: gamesViewModel)
            .tint(appTint)
            .environment(preferences)
            .environment(gamesViewModel)
            .environment(newsViewModel)
            .preferredColorScheme(setColorScheme())
            .sheet(item: $gameToGoToDetailView) { game in
                NavigationStack {
                    if showLoadingView {
                        ProgressView()
                    } else {
                        GameDetailView(game: game, type: .deeplink)
                    }
                }
                .environment(preferences)
                .environment(gamesViewModel)
                .environment(newsViewModel)
            }
            .onOpenURL(perform: { url in
                self.showLoadingView = true

                if UIApplication.shared.canOpenURL(url) {
                    if let gameId = extractProductId(from: url), let id = Int(gameId)  {
                        Task {
                            if let game = try await NetworkManager.shared.fetchGame(id: id).first {
                                await MainActor.run {
                                    self.gameToGoToDetailView = game
                                    self.showLoadingView = false
                                }
                            }
                        }
                    }
                }
            })
    }

    func extractProductId(from url: URL) -> String? {
        let path = url.path
        // Check if the path contains the specified pattern
        if path.contains("product") {
            // Split the path by '/' and get the last component as the product ID
            let pathComponents = path.components(separatedBy: "/")
            if let lastComponent = pathComponents.last {
                return lastComponent
            }
        }
        return nil
    }

}

// MARK: - Color scheme
extension SpeeltuinApp {
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
