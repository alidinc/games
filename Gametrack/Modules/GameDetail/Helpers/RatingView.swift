//
//  RatingView.swift
//  Gametrack
//
//  Created by Ali Dinç on 24/12/2023.
//

import SwiftUI

struct RatingView: View {
    
    var game: Game
    
    var body: some View {
        VStack(alignment: .leading) {
            if let rating = game.totalRating {
                RatingStarsView(rating: Int(5 * rating / 100))
            }
            
            HStack {
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
}
