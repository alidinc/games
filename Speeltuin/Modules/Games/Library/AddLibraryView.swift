//
//  AddLibraryView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 14/01/2024.
//

import SwiftData
import SwiftUI

struct AddLibraryView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    
    var game: Game?
   
    @State private var name = ""
    @State private var icon = ""
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query var savedGames: [SavedGame]
    @Query var libraries: [Library]
    
    @State private var iconsExpanded = false
    @State private var showEmptyNameAlert = false
    @State private var showMaxLibraryAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NameView
                    IconsView(icon: $icon)
                }
                .vSpacing(.top)
            }
            .navigationTitle("Add library")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                VStack {
                    RemainingLibraryCountView
                    AddButton
                }
                .safeAreaPadding(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CloseButton()
                }
            }
        }
        .alert("Please name your library.", isPresented: $showEmptyNameAlert, actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        })
        .alert("You can't have more than 10 libraries.", isPresented: $showMaxLibraryAlert) {
            Button(action: {}, label: {
                Text("OK")
            })
        }
    }
    
    private var NameView: some View {
        TextField("Name", text: $name)
            .frame(height: 24, alignment: .leading)
            .padding()
            .clipShape(.rect(cornerRadius: 8))
            .font(.headline)
            .foregroundStyle(.gray)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
            .padding(.horizontal)
            .autocorrectionDisabled()
    }

    
    private var RemainingLibraryCountView: some View {
        Section {
            Text("\(10 - libraries.count)")
                .font(.headline.bold())
            
            +
            
            Text(" remaining slots to create a library.")
                .font(.subheadline)
        }
        .padding()
        .hSpacing(.leading)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
        .padding(.horizontal)
    }
    
    private var AddButton: some View {
        Button(action: {
            addLibrary()
        }, label: {
            HStack {
                Image(systemName: "plus")
                Text("Add library")
            }
            .hSpacing(.center)
            .foregroundStyle(.white)
            .bold()
            .padding()
            .background(.blue, in: .capsule)
        })
        .padding(.horizontal)
    }
    
    func addLibrary() {
        guard !name.isEmpty || libraries.count < 11 else {
            showEmptyNameAlert = true
            return
        }
        
        let library = Library(title: name, icon: icon)
        let dataManager = SwiftDataManager(modelContainer: context.container)
        
        context.insert(library)
        
        if let game {
            Task {
                await dataManager.toggle(game: game, for: library)
            }
        }
        dismiss()
    }
}
