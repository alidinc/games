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
    @State private var libraryToView: Library?
    @State private var showDeleteAlert = false
    @Query var savedGames: [SavedGame]
    @Query var libraries: [Library]
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                LibraryList
            }
            .sheet(isPresented: $showAddLibrary, content: {
                AddLibraryView()
            })
            .sheet(isPresented: $showLibrary, content: {
                if let libraryToView {
                    LibraryView(library: libraryToView)
                }
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
                Button {
                    self.libraryToView = library
                    self.showLibrary = true
                } label: {
                    TrackRow(trackNumber: "\(index + 1)", trackTitle: library.title)
                }
            }
            .onDelete(perform: deleteLibrary)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func deleteLibrary(at offsets: IndexSet) {
        for index in offsets {
            let library = libraries[index]
            self.libraryToDelete = library
            self.showDeleteAlert = true
        }
    }
}
