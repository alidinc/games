//
//  GameDetailView.swift
//  JustGames
//
//  Created by Ali Dinç on 07/01/2024.
//

import SwiftUI

struct GameDetailView: View {
    
    var game: Game
    
    @State var vm = GameDetailViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ImagesView(game: game)
                    .ignoresSafeArea()
                    .gradientMask(color: .gray)
                
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
        .ignoresSafeArea(edges: .top)
        .toolbarRole(.editor)
    }
}
