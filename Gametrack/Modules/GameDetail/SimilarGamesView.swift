//
//  SimilarGamesView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct SimilarGamesView: View {
    
    var game: Game
    
    @ViewBuilder
    var body: some View {
        if let similarGames = game.similarGames, !similarGames.isEmpty {
            VStack(alignment: .leading) {
                Text("Similar games")
                    .font(.system(size: 16))
                    .padding(.top, 15)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(similarGames, id: \.id) { game in
                            NavigationLink {
                                GameDetailView(game: game)
                            } label: {
                                if let cover = game.cover, let url = cover.url {
                                    AsyncImageView(with: url, type: .grid)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                    .frame(maxWidth: .infinity)
                }
            }
            .cornerRadius(10)
        }
    }
}
