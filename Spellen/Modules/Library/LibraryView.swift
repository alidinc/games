//
//  AddLibraryButton.swift
//  JustGames
//
//  Created by Ali Dinç on 11/01/2024.
//

import SwiftData
import SwiftUI

struct LibraryView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    
    @Environment(\.dismiss) private var dismiss
    @Environment(SavingViewModel.self) private var vm: SavingViewModel
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    @Environment(\.modelContext) private var context
    
    @State private var showAddLibrary = false
    
    @State private var libraryToEdit: Library?
    @State private var libraryToDelete: Library?
    
    @State private var showAlertToDeleteLibrary = false
    
    @Query var savedGames: [SavedGame]
    @Query var libraries: [Library]
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                TotalGames
                AllLibrariesView
            }
            .overlay(content: {
                if libraries.isEmpty {
                    ContentUnavailableView("No libraries found.",
                                           systemImage: "externaldrive.fill.badge.exclamationmark")
                }
            })
            .sheet(item: $libraryToEdit, content: { library in
                EditLibraryView(library: library)
                    .presentationDetents([.fraction(0.7)])
            })
            .sheet(isPresented: $showAddLibrary, content: {
                AddLibraryView()
                    .presentationDetents([.fraction(0.7)])
            })
            .alert("Are you sure to delete this library?", isPresented: $showAlertToDeleteLibrary, actions: {
                Button(role: .destructive) {
                    if let libraryToDelete {
                        vm.delete(library: libraryToDelete, context: context)
                    }
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
        }
    }
    
    private var TotalGames: some View {
        Button {
            gamesVM.headerTitle = "All games"
            gamesVM.headerImageName =  "bookmark"
            gamesVM.searchPlaceholder = "Search in library"
            gamesVM.dataType = .library
            gamesVM.filterType = .library
    
            gamesVM.filterSegment(savedGames: savedGames)
        } label: {
            HStack {
                Text("All")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(savedGames.count) games")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
            }
            .padding(10)
            .background(.black.opacity(0.25), in: .rect(cornerRadius: 10))
            .padding(.horizontal, 20)
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
                
                Text("Tap to edit a library or swipe for more.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .hSpacing(.leading)
            }
            
            Button {
                showAddLibrary = true
            } label: {
                Circle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 30, height: 30)
                    .overlay {
                        SFImage(name: "plus", config: .init(opacity: 0, color: .secondary))
                    }
            }
            
            CloseButton()
        }
        .padding(20)
    }
    
    private var AllLibrariesView: some View {
        List {
            ForEach(libraries, id: \.savingId) { library in
                Button(action: {
                    libraryToEdit = library
                }, label: {
                    HStack {
                        if let icon = library.icon {
                            Image(systemName: icon)
                                .imageScale(.medium)
                        }
                        
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
