//
//  SimilarGamesView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct SimilarGamesView: View {
    
    var similarGames: [Game]
    
    @State private var isExpanded = true
    
    @ViewBuilder
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
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
                }
                .padding(.top)
                .fadeOutSides(length: 100, side: .trailing)
            },
            label: {
                Text("Similar games")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        )
        .padding()
        .background(.black.opacity(0.5), in: .rect(cornerRadius: 10))
        .padding(.horizontal)
        .onTapGesture {
            isExpanded.toggle()
        }
    }
}
