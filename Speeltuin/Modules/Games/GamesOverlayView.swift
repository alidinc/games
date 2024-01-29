//
//  GamesOverlayView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 13/01/2024.
//

import SwiftData
import SwiftUI

struct GamesOverlayView: View {
     
    @Environment(GamesViewModel.self) private var vm
    @Environment(Admin.self) private var admin
    
    private var LoadingView: some View {
        ZStack {
            ProgressView("Please wait, \nwhile we are getting ready! ☺️")
                .font(.subheadline)
                .tint(.gray)
                .multilineTextAlignment(.center)
                .controlSize(.large)
        }
        .hSpacing(.center)
        .padding(.horizontal, 50)
        .ignoresSafeArea()
    }
    
    var body: some View {
        switch vm.dataType {
        case .network:
            switch admin.networkStatus {
            case .available:
                switch vm.dataFetchPhase {
                case .empty:
                    ContentUnavailableView.search(text: vm.searchQuery)
                case .failure:
                    ContentUnavailableView(
                        "No content available",
                        systemImage: "exclamationmark.triangle.fill",
                        description: Text(
                            "We are unable to display any content, please enhance your query."
                        )
                    )
                case .loading:
                    LoadingView
                default:
                    Color.clear
                }
            case .unavailable:
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
            }
        case .library:
            if vm.savedGames.isEmpty {
                switch vm.filterType {
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
