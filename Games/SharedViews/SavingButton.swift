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
    
    @Query var games: [SavedGame]
    @State var name: String?

    
    @Query var libraries: [Library]
    
    var body: some View {
        Menu {
            
            
           
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
