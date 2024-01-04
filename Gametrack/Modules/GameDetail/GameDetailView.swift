//
//  GameDetailView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct GameDetailView: View {
    
    var game: Game?
    @State var vm = GameDetailViewModel()
   
    init(game: Game? = nil, savedGame: SavedGame? = nil) {
        guard let game else {
            self.game = savedGame?.game
            return
        }
        
        self.game = game
    }
    
    var body: some View {
        if let game {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ImagesView(game: game)
                        .ignoresSafeArea(edges: .top)
                        .mask(alignment: .bottom, { GradientMask })
                    
                    VStack(alignment: .leading, spacing: 25) {
                        VStack(alignment: .leading, spacing: 0) {
                            if let name = game.name {
                                HStack {
                                    Text(name)
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    SavingButton(game: game, opacity: 1, padding: 8)
                                }
                            }
                            
                            RatingView(game: game)
                        }
                        .padding(.horizontal)
                        
                        GenresView(game: game)
                            .padding(.leading)
                        
                        SummaryView(game: game)
                        
                        PlatformsView(game: game)
                            .padding(.leading)
                        
                        GameModesView(game: game)
                            .padding(.leading)
                        
                        VideosView(game: game)
                            .padding(.leading)
                        
                        SocialsView(game: game)
                            .padding(.leading)

                        if !vm.gamesFromIds.isEmpty {
                            SimilarGamesView(similarGames: vm.gamesFromIds)
                                .padding(.leading)
                        }
                    }
                    .hSpacing(.leading)
                    .task {
                        if let similarGames = game.similarGames {
                            await vm.fetchGames(from: similarGames)
                        }
                    }
                }
            }
            .padding(.bottom, 10)
            .background(.gray.opacity(0.15))
            .toolbarBackground(.hidden, for: .navigationBar)
            .ignoresSafeArea(edges: .top)
        }
    }
    
    private var GradientMask: some View {
        VStack(spacing: 0) {
            Color.gray
                .frame(maxHeight: .infinity)
    
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .gray, location: 0),
                    Gradient.Stop(color: .clear, location: 1)
                ],
                startPoint: .top,
                endPoint: .center
            )
            .frame(height: 50)
        }
    }
}
