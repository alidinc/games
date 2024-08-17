//
//  AddLibraryButton.swift
//  Speeltuin
//
//  Created by Ali Dinç on 11/01/2024.
//

import SwiftData
import SwiftUI

struct LibrariesView: View {

    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel

    @State private var showAddLibrary = false
    @State private var showLibrary = false
    @State private var libraryToDelete: Library?
    @State private var libraryToEdit: Library?
    @State private var showDeleteAlert = false
    @Query var savedGames: [SavedGame]
    @Query var libraries: [Library]

    var body: some View {
        NavigationStack {
            LibraryList
                .toolbarRole(.editor)
                .navigationTitle("Libraries")
                .sheet(isPresented: $showAddLibrary, content: {
                    AddLibraryView(library: libraryToEdit)
                })
                .confirmationDialog("Are you sure to delete this library?\nYou can't undo this action.",
                                    isPresented: $showDeleteAlert, titleVisibility: .visible, actions: {
                    Button("Delete", role: .destructive) {
                        if let libraryToDelete {
                            context.delete(libraryToDelete)
                        }
                    }
                })
                .toolbar(content: {
                    Button {
                        showAddLibrary.toggle()
                        if hapticsEnabled {
                            HapticsManager.shared.vibrateForSelection()
                        }

                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.headline)
                            .frame(width: 30, height: 30)
                    }
                })
        }
    }

    private var Header: some View {
        HStack {
            VStack {
                Text("Libraries")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .hSpacing(.leading)

                Text("Tap to view a library or swipe for more.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .hSpacing(.leading)
            }


        }
        .padding(20)
    }

    private var LibraryList: some View {
        List {
            ForEach(Array(libraries.enumerated()), id: \.element.id) { index, library in
                NavigationLink {
                    LibraryView(library: library)
                } label: {
                    HStack {
                        Text("\(index + 1)")
                            .font(.body)
                            .foregroundColor(.gray)

                        Text(library.title)
                            .font(.body)
                            .fontWeight(.regular)

                        Spacer()

                        if let savedGames = library.savedGames {
                            Text(savedGames.count, format: .number)
                                .font(.body)
                                .fontWeight(.medium)
                                .padding(.trailing)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        self.libraryToDelete = library
                        self.showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                    Button {
                        self.libraryToEdit = library
                        self.showAddLibrary = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.orange)
                }
            }
            .onDelete(perform: deleteLibrary)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .padding(.vertical)
    }

    private func deleteLibrary(at offsets: IndexSet) {
        for index in offsets {
            let library = libraries[index]
            self.libraryToDelete = library
            self.showDeleteAlert = true
        }
    }
}
