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

    @State private var title: String = ""
    @State private var date: Date = Date()

    var body: some View {
        VStack {
            TextField("Enter library title", text: $title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding()
                .multilineTextAlignment(.center)

            VStack {
                Button(action: saveLibrary) {
                    Text("Save")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(appTint)
                        .opacity(title.isEmpty ? 0.5 : 1)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(title.isEmpty)
                }

                Button(action: cancelAction) {
                    Text("Cancel")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .foregroundStyle(.gray)
                        .cornerRadius(10)
                }

            }
            .padding(.horizontal, 12)
        }
    }

    private func cancelAction() {
        dismiss()
    }

    private func saveLibrary() {
        guard !self.title.isEmpty else {
            return
        }

        let library = Library(title: title, date: date)
        modelContext.insert(library)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save library: \(error.localizedDescription)")
        }

        dismiss()
    }
}
