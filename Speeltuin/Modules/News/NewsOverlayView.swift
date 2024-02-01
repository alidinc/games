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
    @AppStorage("viewType") var viewType: ViewType = .list
    @Query(animation: .easeInOut) private var savedNews: [SPNews]
    
    var body: some View {
        switch vm.dataType {
        case .network:
            switch admin.networkStatus {
            case .available:
                if vm.ign.isEmpty || vm.nintendo.isEmpty || vm.xbox.isEmpty {
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
            case .unavailable:
                ContentUnavailableView(
                    Constants.UnavailableView.networkTitle,
                    systemImage: "exclamationmark.triangle.fill",
                    description: Text(Constants.UnavailableView.networkMessage)
                )
            }
        case .library:
            switch admin.networkStatus {
            default:
                if savedNews.isEmpty {
                    ContentUnavailableView(
                        Constants.UnavailableView.contentTitle,
                        systemImage: "exclamationmark.triangle.fill",
                        description: Text(Constants.UnavailableView.contentNewsMessage)
                    )
                }
            }
        }
    }
}
