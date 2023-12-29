//
//  RatingView.swift
//  Cards
//
//  Created by Ali Dinç on 18/12/2023.
//


import SwiftUI


enum Rating: String, CaseIterable {
    case Exceptional
    case Good
    case Meh
    case Skip
    case NotReviewed = "Rating N/A"
}


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
            if let totalRating = game.totalRating, totalRating != 0 {
                Text(String(format: "%.2f", totalRating))
                    .font(.caption)
                    .fixedSize()
                    .foregroundColor(ratingColor)
                    .frame(alignment: .bottomTrailing)
            }
            
            ratingImage
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(ratingColor)
            
            Text(ratingText)
                .font(.caption)
                .fixedSize()
                .foregroundStyle(ratingColor)
        }
    }
    
    var ratingText: String {
        guard let rating = self.game.totalRating else {
            return Rating.NotReviewed.rawValue
        }
        
        switch Int(rating) {
        case 0...40:
            return Rating.Skip.rawValue
        case 40...50:
            return Rating.Meh.rawValue
        case 50...80:
            return Rating.Good.rawValue
        case 80...100:
            return Rating.Exceptional.rawValue
        default:
            return Rating.NotReviewed.rawValue
        }
    }
    
    var ratingColor: Color {
        guard let rating = self.game.totalRating else {
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
    
    var ratingImage: Image {
        guard let rating = self.game.totalRating else {
            return Image(systemName: "dot.squareshape.fill")
        }
        switch Int(rating) {
        case 0...40:
            return Image(systemName: "arrowtriangle.down.square.fill")
        case 40...50:
            return Image(systemName: "minus.square.fill")
        case 50...80:
            return Image(systemName: "arrowtriangle.up.square")
        case 80...100:
            return Image(systemName: "star.square.fill")
        default:
            return Image(systemName: "dot.squareshape.fill")
        }
    }
}

