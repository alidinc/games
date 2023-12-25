//
//  GameDetailView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct GameDetailView: View {
    
    var game: Game
    
    @State private var vm = GameDetailViewModel()
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ImagesView(game: game)
                    .ignoresSafeArea()
                    .mask(alignment: .bottom, {
                        VStack(spacing: 0) {
                            Color.black
                                .frame(maxHeight: .infinity)
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: .gray, location: 0.00),
                                    Gradient.Stop(color: .clear, location: 1)
                                ],
                                startPoint: .top,
                                endPoint: .center
                            )
                            .frame(height: 40)
                        }
                    })
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        if let name = game.name {
                            Text(name)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.primary)
                                .padding(.horizontal)
                        }

                        GenresView(game: game)
                            .padding(.leading)
                        
                        SummaryView(game: game)

                    }
                    
                    
                    HStack(alignment: .center, spacing: 10) {
                        RatingView(game: game)
                        Divider()
                            .foregroundStyle(.white)
                            .frame(height: 50)
                        
                        PlatformsView(game: game)
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    VideosView(game: game)
                        .padding(.leading)
                    
                    SocialsView(game: game)
                        .padding(.leading)

                    SimilarGamesView(game: game)
                        .padding(.leading)
                }
                .hSpacing(.leading)
            
            }
        }
        .ignoresSafeArea()
        .padding(.bottom, 10)
        .background(.gray.opacity(0.15))
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
