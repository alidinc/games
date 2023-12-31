//
//  ListRowView.swift
//  Cards
//
//  Created by Ali Dinç on 19/12/2023.
//

import SwiftUI

enum ViewReference {
    case network
    case local
}

struct ListRowView: View {
    
    var game: Game?
    var savedGame: SavedGame?
    var reference: ViewReference = .local
    
    init(game: Game?) {
        self.reference = .network
        self.game = game
    }
    
    init(savedGame: SavedGame?) {
        self.reference = .local
        if let savedGame {
            self.game = Game(
                id: savedGame.id,
                name: savedGame.name,
                cover: savedGame.cover,
                firstReleaseDate: savedGame.firstReleaseDate,
                summary: savedGame.summary,
                totalRating: savedGame.totalRating,
                ratingCount: savedGame.ratingCount,
                genres: savedGame.genres,
                platforms: savedGame.platforms,
                releaseDates: savedGame.releaseDates,
                screenshots: savedGame.screenshots,
                gameModes: savedGame.gameModes,
                videos: savedGame.videos,
                websites:  savedGame.websites,
                similarGames: savedGame.similarGames,
                artworks: savedGame.artworks
                )
        }
    }
    
    var platformsText: String {
        guard let platforms = self.game?.platforms else {
            return "N/A"
        }
        
        return platforms.compactMap({$0.name}).joined(separator: ", ")
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let game {
                if let cover = game.cover, let url = cover.url {
                    AsyncImageView(with: url, type: .list)
                        .shadow(radius: 4)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    if let name = game.name {
                        Text(name)
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    ReleaseDateView(game: game)
                    
                    Text(self.platformsText)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        RatingStatusView(game: game)
                        Spacer()
                        
                        SavingButton(game: game, opacity: 0.2, padding: 8)
                    }
                }
            }
        }
        .padding(12)
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
        .frame(maxHeight: .infinity)
        .shadow(radius: 4)
    }
}

struct ReleaseDateView: View {
    
    var game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let firstReleaseDate = self.game.firstReleaseDate  {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    
                    Text("\(firstReleaseDate.numberToDateString())")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                .hSpacing(.leading)
            }
        }
    }
}

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

