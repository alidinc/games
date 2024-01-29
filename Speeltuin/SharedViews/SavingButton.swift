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
    var opacity: CGFloat
    let dataManager: SPDataManager
    
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    @Environment(\.modelContext) private var context
    
    @State private var libraryName: String?
    @Query var games: [SPGame]
    @Query var libraries: [SPLibrary]
    
    var body: some View {
        Menu {
            let libraries = libraries.filter({ !($0.savedGames?.compactMap({$0.game}).contains(game) ?? false) })
            if !libraries.isEmpty {
                Label("Add to : ", systemImage: "arrow.turn.right.down")
            }
            
            ForEach(libraries, id: \.savingId) { library in
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
            if let libraryName {
                Image(systemName: libraryName)
            }
        }
        .task(id: libraryName, priority: .high) {
            getLibraryName()
        }
        .onChange(of: libraryName) { oldValue, newValue in
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
            
            gamesVM.filterSegment(savedGames: games)
        }
    }
    
    @MainActor
    func getLibraryName() {
        Task {
            if let library = await self.dataManager.fetchSavedGames.first(where: { $0.game?.id == game.id })?.library {
                self.libraryName = library.icon
            } else {
                self.libraryName = "bookmark"
            }
        }
    }
}
