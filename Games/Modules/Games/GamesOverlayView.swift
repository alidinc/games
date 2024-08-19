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
            ProgressView("Please wait...")
                .font(.subheadline)
                .tint(.gray)
                .multilineTextAlignment(.center)
        }
        .hSpacing(.center)
        .padding(.horizontal, 50)
        .ignoresSafeArea()
    }
    
    var body: some View {
        Group {
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
        }
       
    }
}
