//
//  CardView.swift
//  Cards
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

struct CardView: View {
    
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
    
    var body: some View {
        if let game, let cover = game.cover, let url = cover.url {
            AsyncImageView(with: url, type: .detail)
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.size.width - 40, height: 500)
                .cornerRadius(20)
                .overlay(alignment: .bottom) {
                    CardContent
                }
        }
    }
    
    @ViewBuilder
    var CardContent: some View {
        if let game {
            ZStack(alignment: .bottom) {
                
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(linearGradient)
                
                VStack(alignment: .leading) {
                    Text(game.name ?? "")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .shadow(color: .black, radius: 10, y: 10)
                        .multilineTextAlignment(.leading)
                    
                    RatingStatusView(game: game)
                }
                .hSpacing(.leading)
                .padding(.horizontal)
                .padding(.vertical, 40)
                .background (
                    LinearGradient(colors: [.clear, .black.opacity(0.85)],
                                   startPoint: .top,
                                   endPoint: .center),
                    in: .rect(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
                )
            }
        }
    }
    
    var linearGradient: LinearGradient {
        LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
    }
}
