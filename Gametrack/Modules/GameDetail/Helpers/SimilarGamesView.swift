//
//  SimilarGamesView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct SimilarGamesView: View {
    
    var similarGames: [Game]
    
    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading) {
            Text("Similar games")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(similarGames, id: \.id) { game in
                        NavigationLink {
                            DetailView(game: game)
                        } label: {
                            if let cover = game.cover, let url = cover.url {
                                AsyncImageView(with: url, type: .grid)
                            }
                        }
                    }
                }
                
                .padding(.bottom, 15)
                .frame(maxWidth: .infinity)
            }
        }
    }
}
