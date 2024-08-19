//
//  SimilarGamesView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct SimilarGamesView: View {
    
    var similarGames: [Game]
    @Binding var showAddLibrary: Bool

    @State private var isExpanded = true
    @Environment(\.colorScheme) var colorScheme

    @ViewBuilder
    var body: some View {
        VStack {
            Divider()

            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(similarGames, id: \.id) { game in
                                NavigationLink {
                                    GameDetailView(game: game, showAddLibrary: $showAddLibrary)
                                } label: {
                                    if let cover = game.cover, let url = cover.url {
                                        AsyncImageView(with: url, type: .grid)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                    .fadeOutSides(side: .trailing)
                },
                label: {
                    Text("Similar games")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)

                }
            )
            .padding(.leading)
            .onTapGesture {
                isExpanded.toggle()
            }
        }
    }
}
