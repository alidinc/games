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
    
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    @Environment(\.modelContext) private var context
    
    @Query var games: [SPGame]
    @State var name: String?

    
    @Query var libraries: [SPLibrary]
    
    var body: some View {
        Menu {
            let libraries = libraries.filter({ !($0.savedGames?.compactMap({$0.gameId}).contains(game.id) ?? false) })
            if !libraries.isEmpty {
                Label("Add to : ", systemImage: "arrow.turn.right.down")
            }
            
            ForEach(libraries, id: \.savingId) { library in
                Button {
                    if hapticsEnabled {
                        HapticsManager.shared.vibrateForSelection()
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
            
            if games.compactMap({$0.gameId}).contains(game.id) {
                Button(role: .destructive) {
                
                    
                    if hapticsEnabled {
                        HapticsManager.shared.vibrateForSelection()
                    }
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
            
        } label: {
            if let name = libraryName() {
                SFImage(
                    config: .init(
                        name: name,
                        padding: 10,
                        iconSize: 20
                    )
                )
                .id(self.name)
            } else {
                SFImage(
                    config: .init(
                        name: "plus.circle.fill",
                        padding: 10,
                        iconSize: 18
                    )
                )
            }
        }
    }
    
    func libraryName() -> String? {
        self.games.first(where: { $0.gameId == game.id })?.library?.icon
    }
}
