//
//  AddLibraryButton.swift
//  Gametrack
//
//  Created by Ali Dinç on 31/12/2023.
//

import SwiftUI

struct AddLibraryButton: View {
    
    @State private var showAddLibrary = false
    @State private var libraryName = ""
    @AppStorage("appTint") var appTint: Color = .purple
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Button {
            showAddLibrary = true
        } label: {
            SFImage(name: "plus")
        }
        .sheet(isPresented: $showAddLibrary, content: {
            AddLibraryView
                .presentationDetents([.medium])
        })
    }
    
    private var AddLibraryView: some View {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Library")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                TextField("", text: $libraryName)
                    .frame(height: 24, alignment: .leading)
                    .padding(10)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
                    .autocorrectionDisabled()
                    .onSubmit {
                        addLibrary()
                    }
                
                
                ScrollView(.horizontal) {
                    HStack {
                        
                    }
                }
            }
            
            Button(action: {
                addLibrary()
            }, label: {
                Label("Add Library", systemImage: "plus")
                    .foregroundStyle(.white)
                    .bold()
                    .padding()
                    .background(appTint.gradient, in: .capsule)
            })
        }
        .padding()
        .vSpacing(.top)
    }
    
    func addLibrary() {
        let library = Library(name: libraryName)
        context.insert(library)
        libraryName = ""
        showAddLibrary = false
    }
}
