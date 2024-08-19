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

    @AppStorage("appTint") private var appTint: Color = .blue
    @AppStorage("colorScheme") private var scheme: SchemeType = .system

    @State private var preferences = Admin()
    @State private var gamesViewModel = GamesViewModel()
    @State private var newsViewModel = NewsViewModel()
    @State private var dataManager = DataManager()
    @State private var sessionManager = SessionManager()

    @State private var showLoadingView = false
    @State private var gameToGoToDetailView: Game?
    @State private var showMainView = false
    @State private var showOnboarding = false
    @State private var showSplash = false

    private var modelContainer: ModelContainer = {
        let schema = Schema([
            Library.self,
            SPNews.self
        ])


        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView(vm: gamesViewModel, newsVM: newsViewModel)
                .tint(appTint)
                .opacity(showMainView ? 1 : 0)
                .onAppear(perform: sessionManager.configureCurrentState)
                .onChange(of: sessionManager.currentState, handleFlow)
                .fullScreenCover(isPresented: $showOnboarding, content: { IntroView() })
                .sheet(item: $gameToGoToDetailView) { game in
                    NavigationStack {
                        if showLoadingView {
                            ProgressView()
                        } else {
                            GameDetailView(game: game, showAddLibrary: .constant(false), type: .deeplink)
                        }
                    }
                }
                .environment(preferences)
                .environment(gamesViewModel)
                .environment(newsViewModel)
                .environment(dataManager)
                .environment(sessionManager)
                .preferredColorScheme(setColorScheme())
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
        .modelContainer(modelContainer)
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

    private func handleFlow(_ oldValue: SessionState?, _ newValue: SessionState?) {
        switch newValue {
        case .loggedIn:
            showMainView = true
        case .onboarding:
            showOnboarding = true
        default:
            showSplash = true
        }
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
