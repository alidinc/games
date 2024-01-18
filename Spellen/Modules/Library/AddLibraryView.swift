//
//  AddLibraryView.swift
//  JustGames
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
    
    @Environment(SavingViewModel.self) private var vm: SavingViewModel
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
                    IconSelectionView
                    RemainingLibraryCountView
                }
                .vSpacing(.top)
            }
            .navigationTitle("Add library")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                AddButton
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
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
            .padding(.horizontal)
            .autocorrectionDisabled()
    }
    
    private var IconSelectionView: some View {
        DisclosureGroup {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], content: {
                    ForEach(SFModels.allSymbols, id: \.self) { symbol in
                        Button(action: {
                            icon = symbol
                        }, label: {
                            Image(systemName: symbol)
                                .padding()
                                .imageScale(.medium)
                                .overlay {
                                    if symbol == icon {
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(appTint, lineWidth: 2)
                                    }
                                }
                        })
                    }
                })
                .padding(.horizontal)
            }
            .frame(height: 175)
        } label: {
            HStack {
                Text("Selected icon")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if !icon.isEmpty {
                    SFImage(name: icon)
                } else {
                    SFImage(name: "star")
                }
            }
            .padding(.vertical, 4)
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
        .padding(.horizontal)
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
        context.insert(library)
        if let game {
            vm.saveGameTo(game: game, games: savedGames, library: library, context: context)
        }
        dismiss()
    }
}
