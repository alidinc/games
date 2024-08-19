//
//  SavingMenu.swift
//  Games
//
//  Created by Ali Dinç on 18/08/2024.
//

import SwiftUI
import SwiftData

struct SavingMenu: View {

    let game: Game
    @Binding var showAddLibrary: Bool
    @Environment(\.modelContext) private var context
    @Environment(DataManager.self) var dataManager
    @Query var libraries: [Library]

    var body: some View {
        Menu {
            // Section for libraries where the game is not saved
            let unsavedLibraries = libraries.filter { library in
                !(library.savedGames?.contains { $0.hasSameGameData(as: game) } ?? false)
            }

            if !unsavedLibraries.isEmpty {
                Label("Add to: ", systemImage: "tray.and.arrow.down.fill")

                ForEach(unsavedLibraries, id: \.id) { library in
                    Button(library.title) {
                        if let savedGame = dataManager.add(game: game, for: library) {
                            context.insert(savedGame)
                        }
                    }
                }
            }

            // Section for libraries where the game is already saved
            let savedLibraries = libraries.filter { library in
                library.savedGames?.contains { $0.hasSameGameData(as: game) } ?? false
            }

            if !savedLibraries.isEmpty {
                Divider()

                Label("Remove from: ", systemImage: "tray.and.arrow.up.fill")

                ForEach(savedLibraries, id: \.id) { library in
                    Button(library.title, role: .destructive) {
                        if let savedGame = library.savedGames?.first(where: { $0.hasSameGameData(as: game) }) {
                            context.delete(savedGame)
                        }
                    }
                }
            }

            Button {
                showAddLibrary = true
            } label: {
                Label("Add a new library", systemImage: "plus")
            }

        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
        }
    }
}
