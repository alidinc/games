//
//  GameDetailView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 07/01/2024.
//

import SwiftUI

enum DetailType {
    case deeplink
    case standard
}


struct GameDetailView: View {
    
    var game: Game?
    var savedGame: SavedGame?
    
    @State var vm = GameDetailViewModel()
    @State private var isExpanded = false
    @State private var isSharePresented = false
    
    var type: DetailType = .standard
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    @Environment(Admin.self) private var admin

    private var gradientColors: [Color] {
        let label = scheme == .dark ? Color.black : Color.white.opacity(0.15)
        return [label, appTint.opacity(0.25)]
    }

    init(game: Game, type: DetailType = .standard) {
        self.game = game
        self.type = type
    }
    
    init(savedGame: SavedGame, type: DetailType = .standard) {
        self.type = type
        if let game = savedGame.game {
            self.game = game
            self.savedGame = savedGame
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                GameImage
                
                if let game {
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
        }
        .padding(.bottom, 1)
        .toolbarRole(.editor)
        .background(LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom))
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: (savedGame?.imageData != nil) || (game != nil) ? .top : .leading)
        .sheet(isPresented: $isSharePresented, onDismiss: {
            print("Dismiss")
        }, content: {
            if let gameId = game?.id, let url = URL(string: "https://hellospeeltuin.web.app/product/\(gameId)")  {
                ActivityViewController(activityItems: [url])
                    .ignoresSafeArea()
                    .presentationDetents([.medium, .large])
            }
        })
    }
    
    @ViewBuilder
    private func Share(urlString: String) -> some View {
        if let game, let name = game.name, let string = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            ShareLink(
                item: string,
                preview: SharePreview("\(name)", icon: Image(.teal))
                
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
                        if let gameId = game.id {
                            Button {
                                isSharePresented = true
                            } label: {
                                SFImage(config: .init(name: "square.and.arrow.up.fill"))
                            }
                        }
                    }
                    
                    SavingButton(game: game)
                }
            }
            
            RatingView(game: game)
        }
    }
    
    
    @ViewBuilder
    private var GameImage: some View {
        switch admin.networkStatus {
        case .available:
            if let game {
                ImagesView(game: game)
                    .ignoresSafeArea()
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
        case .unavailable:
            if let savedGame, let imageData = savedGame.imageData {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.size.width,
                               height: UIScreen.main.bounds.size.height * 0.6)
                        .ignoresSafeArea(edges: .top)
                        .fadeOutSides(length: 100, side: .bottom)
                        .overlay(alignment: .bottomLeading) {
                            if let game = savedGame.game {
                                FeatureGameImage(game: game)
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            if type == .deeplink {
                                CloseButton()
                                    .padding()
                            }
                        }
                }
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
                SimilarGamesView(similarGames: vm.gamesFromIds)
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
