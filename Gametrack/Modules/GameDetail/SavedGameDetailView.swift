//
//  SavedGameDetailView.swift
//  Gametrack
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI

struct SavedGameDetailView: View {
    
    var savedGame: SavedGame
    
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
                        .gradientMask(color:  .gray)
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
                    }
                    .hSpacing(.leading)
                }
                
            }
        }
        .padding(.bottom, 10)
        .background(.gray.opacity(0.15))
        .ignoresSafeArea(edges: savedGame.imageData != nil ? .top : .leading)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

