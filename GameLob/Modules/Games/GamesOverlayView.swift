//
//  GamesOverlayView.swift
//  JustGames
//
//  Created by Ali Dinç on 13/01/2024.
//

import SwiftUI

struct GamesOverlayView: View {
    
    var dataType: DataType
    var filterType: FilterType
     
    @Environment(GamesViewModel.self) private var vm
    @Environment(Preferences.self) private var preferences
    
    var body: some View {
        switch dataType {
        case .network:
            if preferences.networkStatus == .local {
                ContentUnavailableView(
                    "No network available",
                    systemImage: "exclamationmark.triangle.fill",
                    description: Text(
                        "We are unable to display any content as your iPhone is not currently connected to the internet."
                    )
                )
                .task {
                    await vm.refreshTask()
                }
            } else {
                if vm.games.isEmpty {
                    ZStack {
                        ProgressView("Please wait, \nwhile we are getting ready! ☺️")
                            .font(.subheadline)
                            .tint(.white)
                            .multilineTextAlignment(.center)
                            .controlSize(.large)
                    }
                    .hSpacing(.center)
                    .padding(.horizontal, 50)
                    .ignoresSafeArea()
                }
            }
        case .library:
            if vm.savedGames.isEmpty {
                switch filterType {
                case .search:
                    ContentUnavailableView.search(text: vm.searchQuery)
                case .library:
                    ContentUnavailableView(
                        "No content found for this library.",
                        systemImage: "gamecontroller.fill",
                        description: Text(
                            "Please add some games from the discover tab."
                        )
                    )
                case .genre, .platform:
                    ContentUnavailableView(
                        "No content found for selected filters",
                        systemImage: "gamecontroller.fill",
                        description: Text(
                            "Please explore some new games."
                        )
                    )
                }
            }
        }
    }
}
