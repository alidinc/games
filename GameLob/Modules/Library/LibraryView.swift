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
    @Environment(\.modelContext) private var context
    
    @State private var showAddLibrary = false
    
    @State private var libraryToEdit: Library?
    @State private var libraryToDelete: Library?
    
    @State private var showAlertToDeleteLibrary = false
    
    @Query var libraries: [Library]
    
    var body: some View {
        NavigationStack {
            AllLibrariesView
                .overlay(content: {
                    if libraries.isEmpty {
                        ContentUnavailableView("No libraries found.", 
                                               systemImage: "externaldrive.fill.badge.exclamationmark")
                    }
                })
                .navigationTitle("Libraries")
                .navigationBarTitleDisplayMode(.inline)
                .padding(.top)
                .sheet(item: $libraryToEdit, content: { library in
                    EditLibraryView(library: library)
                        .presentationDetents([.fraction(0.55)])
                })
                .sheet(isPresented: $showAddLibrary, content: {
                    AddLibraryView()
                        .presentationDetents([.fraction(0.7)])
                })
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddLibrary = true
                        } label: {
                            Circle()
                                .fill(Color(.secondarySystemBackground))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    SFImage(name: "plus", opacity: 0)
                                }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        CloseButton()
                    }
                })
                .alert("Are you sure to delete this library?", isPresented: $showAlertToDeleteLibrary, actions: {
                    Button(role: .destructive) {
                        if let libraryToDelete {
                            vm.delete(library: libraryToDelete, in: context)
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
    
    
    
    private var AllLibrariesView: some View {
        List {
            let libraries = libraries.filter({ $0.savingId != Constants.allGamesLibraryID })
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
                        
                        Image(systemName: "pencil")
                            .imageScale(.medium)
                        
                    }
                })
                .contentShape(.rect)
                .padding()
                .hSpacing(.leading)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                .swipeActions(allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        libraryToDelete = library
                        showAlertToDeleteLibrary = true
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    .tint(.red)
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
