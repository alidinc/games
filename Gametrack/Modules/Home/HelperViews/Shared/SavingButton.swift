//
//  SavingButton.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI

struct SavingButton: View {
    
    var game: Game
    var opacity: CGFloat
    var padding: CGFloat
    
    @Environment(\.modelContext) private var context
    @Query var games: [SavedGame]
    
    var body: some View {
        Menu {
            ForEach([LibraryType.wishlist, LibraryType.purchased, LibraryType.owned, LibraryType.played], id: \.id) { library in
                Button {
                    handleToggle(library: library)
                } label: {
                    HStack {
                        Text(library.title)
                        SFImage(name:  alreadyExists(game, in: library) ? library.selectedIconName : library.iconName)
                    }
                }
            }
        } label: {
            if let savedGame = games.first(where: { $0.id == game.id }),
               let library = LibraryType(rawValue: savedGame.libraryType) {
                SFImage(name: library.selectedIconName, opacity: opacity, padding: padding, color: library.color)
            } else {
                SFImage(name: "bookmark", opacity: opacity, padding: padding)
            }
        }
    }
    
    
    var isSaved: Bool {
        games.compactMap({$0.id}).contains(game.id)
    }
    
    func alreadyExists(_ game: Game, in library: LibraryType) -> Bool {
        return ((games.first(where: {$0.id == game.id && $0.libraryType == library.id })) != nil)
    }
    
    func handleToggle(library: LibraryType) {
        withAnimation(.snappy) {
            guard self.alreadyExists(game, in: library) else {
                delete()
                add(for: library)
                return
            }
            
            delete()
        }
    }
    
    func delete() {
        if let gameToDelete = games.first(where: { $0.id == game.id }) {
            context.delete(gameToDelete)
        }
    }
    
    func add(for library: LibraryType) {
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
            artworks: game.artworks,
            libraryType: library.id
        )
        context.insert(savedGame)
    }
}
