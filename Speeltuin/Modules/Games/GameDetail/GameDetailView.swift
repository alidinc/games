//
//  GameDetailView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 07/01/2024.
//

import SwiftUI

struct GameDetailView: View {
    
    var game: Game?
    var savedGame: SavedGame?
    
    @State var vm = GameDetailViewModel()
    @Environment(GamesViewModel.self) private var gamesVM
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(Admin.self) private var admin
    
    init(game: Game) {
        self.game = game
    }
    
    init(savedGame: SavedGame) {
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
                        VideosView(game: game)
                        
                        if !vm.gamesFromIds.isEmpty {
                            SimilarGamesView(similarGames: vm.gamesFromIds)
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
        .ignoresSafeArea(edges: game != nil ? .top : .leading)
        .ignoresSafeArea(edges: savedGame?.imageData != nil ? .top : .leading)
        .scrollIndicators(.hidden)
    }
    
    private func Header(game: Game) -> some View {
        VStack(alignment: .leading) {
            if let name = game.name {
                HStack {
                    Text(name)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    SavingButton(game: game, opacity: 1)
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
                }
            }
        }
    }
    
    private func DetailsView(game: Game) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                GenresView(game: game)
                PlatformsView(game: game)
            }
            
            HStack {
                GameModesView(game: game)
                SocialsView(game: game)
            }
        }
        .padding()
        .background(colorScheme == .dark ? .black.opacity(0.5) : .gray.opacity(0.5), in: .rect(cornerRadius: 10))
    }
}
