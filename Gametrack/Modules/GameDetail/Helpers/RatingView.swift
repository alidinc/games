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
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Reviews")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Image(.IGDB)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36)
            }
            
            HStack {
                if let ratingCount = game.ratingCount {
                    Text(String(ratingCount))
                        .font(.footnote)
                }
                
                if let rating = game.totalRating {
                    RatingStarsView(rating: Int(5 * rating / 100))
                }
            }
        }
    }
}
