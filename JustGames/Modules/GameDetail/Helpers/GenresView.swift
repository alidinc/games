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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    let popularGenres = genres.compactMap({ PopularGenre(rawValue: $0.id ?? 0) })
                    ForEach(popularGenres, id: \.id) { genre in
                        HStack {
                            Image(genre.assetName)
                                .resizable()
                                .frame(width: 12, height: 12)
                            
                            Text(genre.title)
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(Color.randomDarkColor.gradient, in: .capsule)
                    }
                }
            }
        }
    }
}