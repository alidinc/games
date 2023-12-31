//
//  SavingButton.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI

struct SavingButton: View {
    
    @Environment(\.modelContext) private var context
    var game: Game
    var opacity: CGFloat
    var padding: CGFloat
    
    @Query var libraries: [Library]
    @Query var games: [SavedGame]
    
    var body: some View {
        Menu {
            ForEach(libraries, id: \.id) { library in
                Button {
                    addGame(from: game, for: library)
                } label: {
                    Text(library.name)
                }
            }
        } label: {
            SFImage(
                name: isSaved ? "bookmark.fill" : "bookmark",
                opacity: opacity,
                padding: padding
            )
        }
    }
    
    var isSaved: Bool {
        games.compactMap({$0.id}).contains(game.id)
    }
    
    func addGame(from game: Game, for library: Library) {
        if isSaved {
            if let gameToDelete = library.games.first(where: { $0.id == game.id }),
               let index = library.games.firstIndex(where: { $0.id == game.id }) {
                library.games.remove(at: index)
                context.delete(gameToDelete)
            }
        } else {
            let savedGame = SavedGame(
                id: game.id,
                name: game.name,
                cover: game.cover,
                firstReleaseDate: game.firstReleaseDate,
                summary: game.summary,
                totalRating: game.totalRating,
                ratingCount: game.ratingCount,
                genres: game.genres,
                platforms: game.platforms,
                releaseDates: game.releaseDates,
                screenshots: game.screenshots,
                gameModes: game.gameModes,
                videos: game.videos,
                websites: game.websites,
                similarGames: game.similarGames,
                artworks: game.artworks
            )
            context.insert(savedGame)
            library.games.append(savedGame)
        }
    }
}
