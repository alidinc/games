//
//  AllLibrariesView.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import SwiftData
import SwiftUI

struct AllLibrariesView: View {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    
    @Query(animation: .easeInOut) var libraries: [SPLibrary]
    @Query(animation: .easeInOut) var savedGames: [SPGame]
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    
    @State private var libraryToEdit: SPLibrary?
    @State private var libraryToDelete: SPLibrary?
    @State private var showAlertToDeleteLibrary = false
    @State private var showAlertToDeleteAllLibraries = false
    
    var body: some View {
        List {
            TotalGames
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                .swipeActions {
                    Button(role: .destructive) {
                        showAlertToDeleteAllLibraries = true
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    .tint(.red)
                }
            
            ForEach(libraries, id: \.savingId) { library in
                Button(action: {
                    gamesVM.librarySelectionTapped(allSelected: false, for: library, in: savedGames)
                    if hapticsEnabled {
                        HapticsManager.shared.vibrateForSelection()
                    }
                    dismiss()
                }, label: {
                    LibraryView(library)
                })
                .padding()
                .hSpacing(.leading)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                .sheet(item: $libraryToEdit, content: { library in
                    EditLibraryView(library: library)
                        .presentationDetents([.fraction(0.7)])
                })
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        libraryToDelete = library
                        showAlertToDeleteLibrary = true
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    .tint(.red)
                    
                    
                    Button(role: .destructive) {
                        libraryToEdit = library
                        if hapticsEnabled {
                            HapticsManager.shared.vibrateForSelection()
                        }
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.orange)
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
        .listStyle(.plain)
        .listRowSpacing(10)
        .scrollContentBackground(.hidden)
        .alert(Constants.Alert.deleteLibraryAlertTitle, isPresented: $showAlertToDeleteLibrary, actions: {
            Button(role: .destructive) {
                if let libraryToDelete, libraries.contains(libraryToDelete) {
                    context.delete(libraryToDelete)
                }
            } label: {
                Text(Constants.Alert.delete)
            }
            
            Button(role: .cancel) {
                
            } label: {
                Text(Constants.Alert.cancel)
            }
        }, message: {
            Text(Constants.Alert.undoAlertTitle)
        })
        .alert(Constants.Alert.deleteAllLibrariesAlertTitle, isPresented: $showAlertToDeleteAllLibraries, actions: {
            Button(role: .destructive) {
                libraries.forEach({context.delete($0)})
            } label: {
                Text(Constants.Alert.delete)
            }
            
            Button(role: .cancel) {
                
            } label: {
                Text(Constants.Alert.cancel)
            }
        }, message: {
            Text(Constants.Alert.undoAlertTitle)
        })
        .overlay(content: {
            if libraries.isEmpty {
                ContentUnavailableView("No libraries found.",
                                       systemImage: "externaldrive.fill.badge.exclamationmark")
            }
        })
    }
    
    @ViewBuilder
    private var TotalGames: some View {
        if !libraries.isEmpty {
            Button {
                gamesVM.headerTitle = "All games"
                gamesVM.searchPlaceholder = "Search in library"
                gamesVM.dataType = .library
                gamesVM.filterType = .library
                gamesVM.selectedLibrary = nil
                gamesVM.filterSegment(savedGames: savedGames)
                
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
                dismiss()
            } label: {
                HStack {
                    Text("All")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color(uiColor: .label))
                    
                    Spacer()
                    
                    Text("\(savedGames.count) games")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color(uiColor: .label))
                }
                .padding()
                .background(.black.opacity(0.25), in: .rect(cornerRadius: 10))
            }
        }
    }
    
    private func LibraryView(_ library: SPLibrary) -> some View {
        HStack {
            Image(systemName: library.icon)
                .imageScale(.medium)
            
            Text(library.title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Spacer()
            
            if let games = library.savedGames {
                Text("\(games.count) games")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
