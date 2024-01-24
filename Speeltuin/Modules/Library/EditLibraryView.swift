//
//  EditLibraryView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 13/01/2024.
//

import SwiftData
import SwiftUI

struct EditLibraryView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    @Bindable var library: Library
    
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query var libraries: [Library]
    @Query var games: [SavedGame]
    @State private var showMaxLibraryAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NameView
                    IconsView(icon: $library.icon)
                }
                .vSpacing(.top)
            }
            .navigationTitle("Edit library")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                UpdateButton
                    .safeAreaPadding(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CloseButton()
                }
            }
        }
        .alert("You can't have more than 10 libraries.", isPresented: $showMaxLibraryAlert) {
            Button(action: {}, label: {
                Text("OK")
            })
        }
    }
    
    private var NameView: some View {
        TextField("Name", text: $library.title)
            .frame(height: 24, alignment: .leading)
            .padding()
            .clipShape(.rect(cornerRadius: 8))
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
            .padding(.horizontal)
            .autocorrectionDisabled()
    }
    
    private var UpdateButton: some View {
        Button {
            if library == gamesVM.selectedLibrary {
                gamesVM.librarySelectionTapped(allSelected: false, for: library, in: games)
            }
            dismiss()
        } label: {
            HStack {
                Image(systemName: "arrow.2.squarepath")
                Text("Update")
            }
            .hSpacing(.center)
            .foregroundStyle(.white)
            .bold()
            .padding()
            .background(.blue, in: .capsule)
        }
        .padding(.horizontal)
    }
}
