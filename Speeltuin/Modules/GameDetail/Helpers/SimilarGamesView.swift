//
//  SimilarGamesView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct SimilarGamesView: View {
    
    var similarGames: [Game]
    let dataManager: DataManager
    
    @State private var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    
    @ViewBuilder
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(similarGames, id: \.id) { game in
                            NavigationLink {
                                GameDetailView(game: game, dataManager: dataManager)
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
        .padding()
        .background(colorScheme == .dark ? .ultraThickMaterial : .ultraThick, in: .rect(cornerRadius: 10))
        .shadow(radius: 2)
        .onChange(of: isExpanded) { oldValue, newValue in
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        }
    }
}
