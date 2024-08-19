//
//  RatingView.swift
//  Speeltuin
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

import SwiftUI

struct ListItemRatingView: View {
    var game: Game

    private var ratingColor: Color {
        guard let rating = game.totalRating else {
            return Color.gray
        }
        switch Int(rating) {
        case 0...40:
            return Color.red
        case 40...50:
            return Color.orange
        case 50...80:
            return Color.blue
        case 80...100:
            return Color.green
        default:
            return Color.gray
        }
    }

    private var ratingImageName: String {
        guard let rating = game.totalRating else {
            return "smallcircle.filled.circle.fill"
        }
        switch Int(rating) {
        case 0...40:
            return "arrowtriangle.down.circle.fill"
        case 40...50:
            return "minus.circle.fill"
        case 50...80:
            return "arrowtriangle.up.circle.fill"
        case 80...100:
            return "star.circle.fill"
        default:
            return "smallcircle.filled.circle.fill"
        }
    }

    var body: some View {
        Image(systemName: ratingImageName)
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundStyle(ratingColor)
    }
}
