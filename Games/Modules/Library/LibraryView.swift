//
//  LibraryView.swift
//  Games
//
//  Created by Ali Dinç on 17/08/2024.
//

import SwiftUI
import SwiftData

struct LibraryView: View {

    let library: Library

    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.colorScheme) private var scheme
    @Environment(\.modelContext) private var context

    @State private var gameToDelete: SavedGame?
    @State private var showDeleteAlert = false
    @State private var selectedGame: SavedGame?

    @Query private var libraries: [Library]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if let savedGames = library.savedGames {
                    List {
                        ForEach(savedGames) { data in
                            ListItemView(game: data.game)
                                .navigationLink({
                                    GameDetailView(savedGame: data)
                                })
                        }
                        .onDelete(perform: deleteGame)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.vertical, 12)
                }
            }
            .confirmationDialog("Are you sure to delete this game from your library?\nYou can't undo this action.",
                                isPresented: $showDeleteAlert, titleVisibility: .visible, actions: {
                Button("Delete", role: .destructive) {
                    if let gameToDelete {
                        context.delete(gameToDelete)
                    }
                }
            })
        }
    }

    private func deleteGame(at offsets: IndexSet) {
        if let index = offsets.first, index < (library.savedGames?.count ?? 0) {
            // Fetch the game to be deleted
            self.showDeleteAlert = true
            self.gameToDelete = library.savedGames?[index]
            // Show the confirmation alert
        }
    }
}
