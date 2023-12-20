//
//  RatingView.swift
//  Cards
//
//  Created by Ali Dinç on 18/12/2023.
//


import SwiftUI

struct RatingStatusView: View {
    
    @State var game: Game
    
    var body: some View {
        HStack {
            RatingStatusView(for: self.game)
        }
    }
    
    @ViewBuilder
    private func RatingStatusView(for game: Game) -> some View {
        HStack {
//            if let totalRating = game.totalRating, totalRating != 0 {
//                Text(String(format: "%.2f", totalRating))
//                    .font(.caption)
//                    .fixedSize()
//                    .foregroundColor(game.ratingColor)
//                    .frame(alignment: .bottomTrailing)
//            }
            
            game.ratingImage
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(game.ratingColor)
            
            Text(game.ratingText)
                .font(.caption)
                .fixedSize()
                .foregroundStyle(game.ratingColor)
        }
    }
}

