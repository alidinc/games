//
//  AllLibrariesView.swift
//  Spellen
//
//  Created by alidinc on 23/01/2024.
//

import SwiftData
import SwiftUI

struct AllLibrariesView: View {
    
    @Query(animation: .easeInOut) var libraries: [Library]
    @Query var savedGames: [SavedGame]
    @Environment(\.modelContext) private var context
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    @Environment(SavingViewModel.self) private var savingVM: SavingViewModel
    
    @State private var libraryToEdit: Library?
    @State private var showAlertToDeleteLibrary = false
    
    var body: some View {
        List {
            ForEach(libraries, id: \.savingId) { library in
                Button(action: {
                    gamesVM.librarySelectionTapped(allSelected: false, for: library, in: savedGames)
                }, label: {
                    HStack {
                        Image(systemName: library.icon)
                            .imageScale(.medium)
                        
                        Text(library.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        if let savedGames = library.savedGames {
                            Text("\(savedGames.count) games")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                })
                .contentShape(.rect)
                .padding()
                .hSpacing(.leading)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                .sheet(item: $libraryToEdit, content: { library in
                    EditLibraryView(library: library)
                        .presentationDetents([.fraction(0.7)])
                })
                .alert("Are you sure to delete this library?", isPresented: $showAlertToDeleteLibrary, actions: {
                    Button(role: .destructive) {
                        savingVM.delete(library: library, context: context)
                    } label: {
                        Text("Delete")
                    }
                    
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Cancel")
                    }
                }, message: {
                    Text("You won't be able to undo this action.")
                })
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        showAlertToDeleteLibrary = true
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    .tint(.red)
                    
                    
                    Button(role: .destructive) {
                        libraryToEdit = library
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.orange)
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
