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
    
    @Query(animation: .easeInOut) var games: [SavedGame]
    @Query(animation: .easeInOut) var libraries: [Library]
    
    var body: some View {
        Menu {
            if !(libraries.filter({$0.savingId != Constants.allGamesLibraryID })).isEmpty {
                Label("Add to : ", systemImage: "arrow.turn.right.down")
            }
            
            ForEach(libraries.filter({ !($0.savedGames?.compactMap({$0.game}).contains(game) ?? false) }), id: \.savingId) { library in
                Button {
                    vm.saveGameTo(game: game, games: games, library: library, context: context)
                } label: {
                    HStack {
                        if let icon = library.icon {
                            Image(systemName: icon)
                                .imageScale(.medium)
                        }
                        
                        Text(library.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
            }
            
            Divider()
            
            Button(action: {
                NotificationCenter.default.post(name: .newLibraryButtonTapped, object: nil)
            }, label: {
                Label("New library", systemImage: "plus")
            })
            
            if vm.savedAlready(game: game, games: games) {
                Button(role: .destructive) {
                    vm.deleteFromAll(game: game, in: games, context: context)
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
                
                Divider()
            }
        } label: {
            if vm.savedAlready(game: game, games: games) {
                if let library = getLibrary(), let icon = library.icon {
                    SFImage(
                        name: icon,
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
