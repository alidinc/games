//
//  AddLibraryView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 14/01/2024.
//

import SwiftData
import SwiftUI

struct AddLibraryView: View {
    
    @AppStorage("appTint") var appTint: Color = .blue
    
    var game: Game?
    let dataManager: DataManager
   
    @State private var name = ""
    @State private var icon = ""
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query var savedGames: [SPGame]
    @Query var libraries: [SPLibrary]
    
    @State private var iconsExpanded = false
    @State private var showEmptyNameAlert = false
    @State private var showMaxLibraryAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    RemainingLibraryCountView
                    NameView
                }
                .vSpacing(.top)
            }
            .navigationTitle("Add library")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 20) {
                    IconsView(icon: $icon)
                    AddButton
                }
                .safeAreaPadding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CloseButton()
                }
            }
        }
        .presentationDragIndicator(.visible)
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
            .foregroundStyle(Color(uiColor: .label))
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
        guard !name.isEmpty else {
            showEmptyNameAlert = true
            return
        }
        
        guard libraries.count < 11 else {
            showMaxLibraryAlert = true
            return
        }
        
        if icon.isEmpty {
            self.icon = "bookmark.fill"
        }
        
        let library = SPLibrary(title: name, icon: icon)
        
        Task {
            let dataManager = DataManager(modelContainer: context.container)
            await dataManager.addLibrary(library: library)
            
            Task {
                if let game {
                    await dataManager.toggle(game: game, for: library)
                }
            }
        }
        
        dismiss()
    }
}
