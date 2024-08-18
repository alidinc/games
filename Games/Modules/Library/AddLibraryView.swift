//
//  AddLibraryView.swift
//  Games
//
//  Created by Ali Dinç on 17/08/2024.
//

import SwiftUI
import SwiftData

struct AddLibraryView: View {

    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss

    let library: Library?
    let onSave: (Library) -> Void

    @State private var title: String = ""
    @State private var date: Date = Date()

    // Initializer with optional library parameter
    init(library: Library? = nil, onSave: @escaping (Library) -> Void) {
        self.library = library
        self.onSave = onSave
    }

    var body: some View {
        VStack {
            TextField("Enter Library Title", text: $title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal)
                .multilineTextAlignment(.center)

            Button(action: saveLibrary) {
                Text("Save")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(appTint)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            if let library = library {
                title = library.title
                date = library.date
            }
        }
    }

    private func saveLibrary() {
        let savedLibrary: Library

        if let library = library {
            library.title = title
            library.date = date
            savedLibrary = library
        } else {
            savedLibrary = Library(title: title, date: date)
            modelContext.insert(savedLibrary)
        }

        do {
            try modelContext.save()
            onSave(savedLibrary)
        } catch {
            print("Failed to save library: \(error.localizedDescription)")
        }

        dismiss()
    }
}
