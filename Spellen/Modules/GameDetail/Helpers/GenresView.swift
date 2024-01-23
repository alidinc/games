//
//  GenresView.swift
//  JustGames
//
//  Created by Ali Dinç on 24/12/2023.
//

import SwiftUI

struct GenresView: View {
    
    var game: Game
    
    var body: some View {
        if let genres = game.genres {
            VStack(alignment: .leading) {
                Text("Genres")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        let popularGenres = genres.compactMap({ PopularGenre(rawValue: $0.id ?? 0) })
                        ForEach(popularGenres, id: \.id) { genre in
                            CapsuleView(imageName: genre.assetName)
                        }
                    }
                }
                .mask(alignment: .trailing, {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black]),
                        startPoint: .trailing,
                        endPoint: .center
                    )
                    .opacity(genres.count > 4 ? 1 : 0)
                })
            }
        }
    }
}
