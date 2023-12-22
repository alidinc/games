//
//  GameDetailView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct GameDetailView: View {
    
    var game: Game
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ImagesView(game: game)
                    .mask(alignment: .bottom, {
                        VStack(spacing: 0) {
                            Color.black.frame(maxHeight: .infinity)
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: .black, location: 0.00),
                                    Gradient.Stop(color: .black.opacity(0), location: 1)
                                ],
                                startPoint: .top,
                                endPoint: .center
                            )
                            .frame(height: 60)
                        }
                    })
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    if let name = game.name {
                        Text(name)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(.top)
                            .padding(.leading)
                    }
                    
                    if let platforms = game.platforms {
                        PlatformsView(platforms: platforms)
                            .padding(.top)
                            .padding(.horizontal)
                            .hSpacing(.trailing)
                    }
                    
                    
//                    Text(game.ratingText)
//                        .font(.caption)
//                        .bold()
//                        .foregroundStyle(.primary)
//                        .padding(.vertical, 6)
//                        .padding(.horizontal, 10)
//                        .background(game.ratingColor.gradient, in: .capsule)
//                        .padding()
                    
                    
                   
                    
                    if let summary = game.summary {
                        Text(summary)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .padding()
                    }
                    
                    
                    
                    
                    Spacer()
                    
                    SimilarGamesView(game: game)
                    
                    SocialsView(game: game)
                    
                    
                    HStack(spacing: 10) {
                        if let ratingCount = game.ratingCount {
                            Text(String(ratingCount))
                                .font(.footnote)
                        }
                        
                        if let rating = game.totalRating {
                            RatingStarsView(rating: Int(5 * rating / 100))
                        }
                        
                        Image(.IGDB)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36)
                    }
                    .hSpacing(.trailing)
                }
                .hSpacing(.leading)
                .offset(y: -50)
                
                
                
                Spacer()
            }
            
        }
        .ignoresSafeArea()
        .padding(.bottom)
        .background(.black)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
