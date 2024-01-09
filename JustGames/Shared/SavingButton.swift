//
//  SavingButton.swift
//  JustGames
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI
import Combine

struct SavingButton: View {
    
    var game: Game
    var opacity: CGFloat
    var padding: CGFloat
    
    @Environment(SavingViewModel.self) private var vm: SavingViewModel
    @Environment(\.modelContext) private var context
    
    @Query var games: [SavedGame]
    
    var body: some View {
        Menu {
            ForEach([LibraryType.wishlist,
                     LibraryType.purchased,
                     LibraryType.owned,
                     LibraryType.played], id: \.id) { library in
                Button {
                    vm.handleToggle(
                        game: game,
                        library: library,
                        games: games,
                        context: context
                    )
                } label: {
                    HStack {
                        Text(library.title)
                        SFImage(name:  vm.alreadyExists(game, games: games, in: library) ? library.selectedIconName : library.iconName)
                    }
                }
            }
        } label: {
            if let savedGame = games.first(where: { $0.game?.id == game.id }), let library = LibraryType(rawValue: savedGame.library) {
                
                SFImage(
                    name: library.selectedIconName,
                    opacity: opacity,
                    padding: padding,
                    color: library.color
                )
            } else {
                SFImage(
                    name: "bookmark",
                    opacity: opacity,
                    padding: padding
                )
            }
        }
    }
}
