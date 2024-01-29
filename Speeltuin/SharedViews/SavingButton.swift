//
//  SavingButton.swift
//  Speeltuin
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI
import Combine

struct SavingButton: View {
    
    var game: Game
    var config: SFConfig
    let dataManager: DataManager
    
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    @Environment(\.modelContext) private var context
    
    @Query var games: [SPGame]
    @Query var libraries: [SPLibrary]
    
    var body: some View {
        Menu {
            let libraries = libraries.filter({ !($0.savedGames?.compactMap({$0.game}).contains(game) ?? false) })
            if !libraries.isEmpty {
                Label("Add to : ", systemImage: "arrow.turn.right.down")
            }
            
            ForEach(libraries, id: \.persistentModelID) { library in
                Button {
                    Task {
                        await dataManager.toggle(game: game, for: library)
                    }
                } label: {
                    Label(library.title, systemImage: library.icon)
                }
            }
            
            Divider()
            
            Button(action: {
                NotificationCenter.default.post(name: .newLibraryButtonTapped, object: game)
            }, label: {
                Label("New library", systemImage: "plus")
            })
            .tint(appTint)
            
            if games.compactMap({$0.game}).contains(game) {
                Button(role: .destructive) {
                    Task {
                        await dataManager.delete(game: game)
                    }
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }

        } label: {
            SFImage(name: getLibraryName(), 
                    config: .init(opacity: config.opacity, padding: config.padding))
        }
    }
    
    func getLibraryName() -> String {
        if let library = self.games.first(where: { $0.game?.id == game.id })?.library {
            return library.icon
        } else {
            return "bookmark"
        }
    }
}
