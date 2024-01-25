//
//  SimilarGamesView.swift
//  Speeltuin
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
                .padding(.top)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(.black.opacity(0.5), in: .rect(cornerRadius: 10))
        .padding(.horizontal)
    }
}
