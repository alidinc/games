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
                        Constants.UnavailableView.contentTitle,
                        systemImage: "exclamationmark.triangle.fill",
                        description: Text(Constants.UnavailableView.contentGamesMessage)
                    )
                case .loading:
                    LoadingView
                default:
                    Color.clear
                }
            case .unavailable:
                ContentUnavailableView(
                    Constants.UnavailableView.networkTitle,
                    systemImage: "exclamationmark.triangle.fill",
                    description: Text(Constants.UnavailableView.networkMessage)
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
                        Constants.UnavailableView.contentLibraryTitle,
                        systemImage: "gamecontroller.fill",
                        description: Text(Constants.UnavailableView.contentLibraryMessage)
                    )
                case .genre, .platform:
                    ContentUnavailableView(
                        Constants.UnavailableView.contentFiltersTitle,
                        systemImage: "gamecontroller.fill",
                        description: Text(Constants.UnavailableView.contentGamesMessage)
                    )
                }
            }
        }
    }
}
