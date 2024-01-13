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
    
    
    
    @AppStorage("appTint") var appTint: Color = .white
    @Environment(SavingViewModel.self) private var vm: SavingViewModel
    @Environment(\.modelContext) private var context
    
    @Query var games: [SavedGame]
    @Query var libraries: [Library]
    
    var body: some View {
        Menu {
            if !(libraries.filter({$0.savingId != Constants.allGamesLibraryID })).isEmpty {
                Label("Add/Remove: ", systemImage: "arrow.turn.right.down")
            }
            
            ForEach(libraries.filter({$0.savingId != Constants.allGamesLibraryID }), id: \.self) { library in
                Button(role: vm.savedAlreadyLibrarySpecific(game, for: library, games: games) ? .destructive : .cancel) {
                    
                    vm.saveGameTo(game: game, games: games, library: library, libraries: libraries, context: context)
                } label: {
                    let title = "\(vm.savedAlreadyLibrarySpecific(game, for: library, games: games) ? "Remove from" : "") \(library.title.capitalized)"
                    if let icon = library.icon {
                        Label(title, systemImage: icon)
                    }
                }
            }
            
            Divider()
            
            Button(action: {
                NotificationCenter.default.post(name: .newLibraryButtonTapped, object: nil)
            }, label: {
                Label("New library", systemImage: "plus")
            })
            
            if !vm.savedAlready(game: game, games: games) {
                Button(action: {
                    vm.saveToAllFirst(game: game, games: games, libraries: libraries, context: context)
                }, label: {
                    Label("Save", systemImage: "bookmark")
                })
                
                Divider()
            } else {
                Button(role: .destructive) {
                    vm.delete(game: game, in: games, context: context)
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
                
                Divider()
            }
        } label: {
            if vm.savedAlready(game: game, games: games) {
                if let library = getLibrary(), let iconName = library.icon {
                    SFImage(
                        name: iconName,
                        opacity: opacity,
                        padding: padding,
                        color: appTint
                    )
                } else {
                    SFImage(
                        name: "bookmark.fill",
                        opacity: opacity,
                        padding: padding,
                        color: appTint
                    )
                }
            } else {
                SFImage(
                    name: "bookmark",
                    opacity: opacity,
                    padding: padding,
                    color: appTint
                )
            }
        }
    }
    
    func getLibrary() -> Library? {
        games.first(where: { $0.game?.id == game.id })?.library
    }
}
