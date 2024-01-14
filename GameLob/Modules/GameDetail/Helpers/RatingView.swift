//
//  RatingView.swift
//  JustGames
//
//  Created by Ali Dinç on 24/12/2023.
//

import SwiftUI

struct RatingView: View {
    
    var game: Game
    
    var body: some View {
        HStack {
            if let rating = game.totalRating {
                RatingStarsView(rating: Int(5 * rating / 100))
            }
            
            if let ratingCount = game.ratingCount {
                Text("\(String(ratingCount)) Reviews")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Image(.IGDB)
                .resizable()
                .scaledToFit()
                .frame(width: 34)
        }
    }
}
