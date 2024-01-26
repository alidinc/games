//
//  SavedGameDetailView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI

struct SavedGameDetailView: View {
    
    var savedGame: SavedGame
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let imageData = savedGame.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.size.width,
                               height: UIScreen.main.bounds.size.height * 0.6)
                        .ignoresSafeArea(edges: .top)
                        .fadeOutSides(length: 100, side: .bottom)
                }
                
                if let game = savedGame.game {
                    VStack(alignment: .leading, spacing: 25) {
                        VStack(alignment: .leading, spacing: 0) {
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
                        .padding(.horizontal)
                        
                        SummaryView(game: game)
                        
                        DetailsView(game: game)
                        
                        Spacer(minLength: 20)
                    }
                    .hSpacing(.leading)
                }
                
            }
        }
        .padding(.bottom, 1)
        .background(.gray.opacity(0.15))
        .ignoresSafeArea(edges: savedGame.imageData != nil ? .top : .leading)
        .scrollIndicators(.hidden)
        .toolbarBackground(.hidden, for: .navigationBar)
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
        .background(colorScheme == .dark ? .ultraThinMaterial : .ultraThick, in: .rect(cornerRadius: 10))
        .padding(.horizontal)
    }
}

