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
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    @Environment(\.modelContext) private var context
    
    @Query var games: [SavedGame]
    @Query var libraries: [Library]
    
    var body: some View {
        Menu {
            let libraries = libraries.filter({ !($0.savedGames?.compactMap({$0.game}).contains(game) ?? false) })
            if !libraries.isEmpty {
                Label("Add to : ", systemImage: "arrow.turn.right.down")
            }
            
            ForEach(libraries, id: \.savingId) { library in
                Button {
                    vm.saveGameTo(game: game, games: games, library: library, context: context)
                    gamesVM.filterSegment(savedGames: games, library: library)
                } label: {
                    HStack {
                        Image(systemName: library.icon)
                            .imageScale(.medium)
                        
                        Text(library.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
            }
            
            Divider()
            
            Button(action: {
                NotificationCenter.default.post(name: .newLibraryButtonTapped, object: game)
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
            SFImage(
                name: libraryName(),
                config: .init(
                    opacity: opacity,
                    padding: padding,
                    color: appTint
                )
            )
        }
    }
    
    func libraryName() -> String {
        if let library = games.first(where: { $0.game?.id == game.id })?.library {
            return library.icon
        }
        
        return "bookmark"
    }
}
