//
//  NewsOverlayView.swift
//  Speeltuin
//
//  Created by alidinc on 01/02/2024.
//

import SwiftUI
import SwiftData

struct NewsOverlayView: View {
    
    @Environment(NewsViewModel.self) private var vm: NewsViewModel
    @Environment(Admin.self) private var admin
    @AppStorage("viewType") var viewType: ViewType = .grid
    @Query(animation: .easeInOut) private var savedNews: [SPNews]
    
    var body: some View {
        switch admin.networkStatus {
        case .available:
            if vm.news.isEmpty {
                ZStack {
                    ProgressView("Please wait...")
                        .font(.subheadline)
                        .tint(.white)
                        .multilineTextAlignment(.center)
                        .controlSize(.large)
                }
                .hSpacing(.center)
                .padding(.horizontal, 50)
                .ignoresSafeArea()
            }
        case .unavailable:
            ContentUnavailableView(
                Constants.UnavailableView.networkTitle,
                systemImage: "exclamationmark.triangle.fill",
                description: Text(Constants.UnavailableView.networkMessage)
            )
        }
    }
}
