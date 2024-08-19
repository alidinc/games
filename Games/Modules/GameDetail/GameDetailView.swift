//
//  GameDetailView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 07/01/2024.
//

import SwiftUI
import SwiftData

enum DetailType {
    case deeplink
    case standard
}


struct GameDetailView: View {
    
    var game: Game
    @Binding var showAddLibrary: Bool

    @State var vm = GameDetailViewModel()
    @State private var isExpanded = false
    @State private var isSharePresented = false
    
    var type: DetailType = .standard
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    @Environment(\.modelContext) private var context
    @Environment(Admin.self) private var admin
    @Environment(DataManager.self) private var dataManager

    @Query private var libraries: [Library]

    private var gradientColors: [Color] {
        let label = scheme == .dark ? Color.black : Color.white.opacity(0.15)
        return [label, appTint.opacity(0.25)]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                GameImage

                VStack(alignment: .leading, spacing: 25) {
                    Header(game: game)
                    SummaryView(game: game)
                    DetailsView(game: game)
                    Spacer(minLength: 20)
                }
                .padding(.horizontal)
                .task {
                    if let similarGames = game.similarGames {
                        await vm.fetchGames(from: similarGames)
                    }
                }
            }
        }
        .padding(.bottom, 1)
        .toolbarRole(.editor)
        .navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
        .sheet(isPresented: $isSharePresented, onDismiss: {
            print("Dismiss")
        }, content: {
            if let gameId = game.id, let url = URL(string: "https://hellospeeltuin.web.app/product/\(gameId)")  {
                ActivityViewController(activityItems: [url])
                    .ignoresSafeArea()
                    .presentationDetents([.medium, .large])
            }
        })
    }
    
    @ViewBuilder
    private func Share(urlString: String) -> some View {
        if let name = game.name, let string = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            ShareLink(
                item: string,
                preview: SharePreview("\(name)", icon: Image(.icon))
                
            ) {
                SFImage(config: .init(name: "square.and.arrow.up.fill"))
            }
        }
    }

    private func Header(game: Game) -> some View {
        VStack(alignment: .leading) {
            if let name = game.name {
                HStack {
                    Text(name)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    if type != .deeplink {
                        if let _ = game.id {
                            Button {
                                isSharePresented = true
                            } label: {
                                SFImage(config: .init(name: "square.and.arrow.up.fill"))
                            }
                        }
                    }
                    
                    SavingMenu(game: game, showAddLibrary: $showAddLibrary)
                }
            }
            
            RatingView(game: game)
        }
    }
    
    
    @ViewBuilder
    private var GameImage: some View {
        ImagesView(game: game)
            .fadeOutSides(length: 100, side: .bottom)
            .overlay(alignment: .bottomLeading) {
                FeatureGameImage(game: game)
            }
            .overlay(alignment: .topTrailing) {
                if type == .deeplink {
                    CloseButton()
                        .padding()
                }
            }
    }

    private func DetailsView(game: Game) -> some View {
        VStack(alignment: .leading) {
            GenresView(game: game)
            PlatformsView(game: game)
            GameModesView(game: game)
            SocialsView(game: game)
            VideosView(game: game)
            if !vm.gamesFromIds.isEmpty {
                SimilarGamesView(similarGames: vm.gamesFromIds, showAddLibrary: $showAddLibrary)
            }
        }
        .padding()
        .glass()
    }
}


import UIKit
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.modalPresentationStyle = .formSheet
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
    
}
