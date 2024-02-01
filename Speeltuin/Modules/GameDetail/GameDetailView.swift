//
//  GameDetailView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 07/01/2024.
//

import SwiftUI

struct GameDetailView: View {
    
    var game: Game?
    var savedGame: SPGame?
    let dataManager: DataManager
    
    @State var vm = GameDetailViewModel()
    @State private var isExpanded = false
    @Environment(GamesViewModel.self) private var gamesVM
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(Admin.self) private var admin
    
    init(game: Game, dataManager: DataManager) {
        self.game = game
        self.dataManager = dataManager
    }
    
    init(savedGame: SPGame, dataManager: DataManager) {
        self.dataManager = dataManager
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
                    VStack(alignment: .leading, spacing: 20) {
                        Header(game: game)
                        SummaryView(game: game)
                        DetailsView(game: game)
                            .scrollTargetLayout()
                        VideosView(game: game)
                        
                        if !vm.gamesFromIds.isEmpty {
                            SimilarGamesView(similarGames: vm.gamesFromIds, dataManager: dataManager)
                        }
                        
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
        .background(.gray.opacity(0.15))
        .ignoresSafeArea(edges: (savedGame?.imageData != nil) || (game != nil) ? .top : .leading)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
    }
    
    private func Header(game: Game) -> some View {
        VStack(alignment: .leading) {
            if let name = game.name {
                HStack {
                    Text(name)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    SavingButton(game: game,
                                 config: .init(opacity: 0.25),
                                 dataManager: dataManager)
                }
            }
            
            RatingView(game: game)
        }
    }
    
    @ViewBuilder
    private var FeaturedGameImage: some View {
        if let game, let name = game.name {
            if (name.lowercased().contains("mario")) {
                Image(.mario)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .offset(y: 30)
            } else if (name.lowercased().contains("zelda")) {
                Image(.zelda)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .offset(y: 30)
            } else if (name.lowercased().contains("assassin's creed")) {
                Image(.assassinsCreed)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .offset(y: 30)
            } else if (name.lowercased().contains("the witcher")) {
                Image(.witcher)
                    .resizable()
                    .frame(width: 120, height: 50)
                    .padding()
                    .offset(y: 30)
            } else if (name.lowercased().contains("red dead redemption")) {
                Image(.reddead)
                    .resizable()
                    .frame(width: 150, height: 50)
                    .padding()
                    .offset(y: 30)
            } else if (name.lowercased().contains("grand theft auto")) {
                Image(.gta)
                    .resizable()
                    .frame(width: 60, height: 50)
                    .padding()
                    .offset(y: 30)
            } else if (name.lowercased().contains("marvel")), let summary = game.summary, summary.lowercased().contains("marvel") {
                Image(.marvel)
                    .resizable()
                    .frame(width: 60, height: 50)
                    .padding()
                    .offset(y: 30)
            } else if (name.lowercased().contains("lego")) {
                Image(.lego)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .offset(y: 30)
            } else if (name.lowercased().contains("lord of the rings")) {
                Image(.lord)
                    .resizable()
                    .frame(width: 200, height: 50)
                    .padding()
                    .offset(y: 30)
            } else if (name.lowercased().contains("pokémon")) {
                Image(.pokemon)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .offset(y: 30)
            }
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
                        FeaturedGameImage
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
                            FeaturedGameImage
                        }
                }
            }
        }
    }
    
    private func DetailsView(game: Game) -> some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 30) {
                GenresView(game: game)
                PlatformsView(game: game)
                GameModesView(game: game)
                LinksView(game: game)
            }
        } label: {
            Text(isExpanded ? "" : "Details")
                .font(.subheadline.bold())
                .foregroundColor(.primary)
        }
        .padding()
        .background(colorScheme == .dark ? .ultraThickMaterial : .ultraThick, in: .rect(cornerRadius: 10))
        .shadow(radius: 2)
        .onChange(of: isExpanded) { oldValue, newValue in
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        }
    }
}
