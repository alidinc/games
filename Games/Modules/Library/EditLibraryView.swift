//
//  EditLibraryView.swift
//  Games
//
//  Created by Ali Dinç on 19/08/2024.
//

import SwiftUI

struct EditLibraryView: View {

    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss

    @Binding var library: Library?

    let onDismiss: () -> Void

    @State private var title: String = ""
    @State private var date = Date.now

    var body: some View {
        VStack {
            TextField("Enter library title", text: $title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding()
                .multilineTextAlignment(.center)

            HStack {
                Button(action: deleteLibrary) {
                    Text("Delete")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(.red.opacity(0.5))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }

                Button(action: saveLibrary) {
                    Text("Update")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(appTint)
                        .opacity(title == library?.title ? 0.5 : 1)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .disabled(title == library?.title)
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
        .onAppear {
            if let library {
                self.title = library.title
            }
        }
    }

    private func cancelAction() {
        dismiss()
    }

    private func deleteLibrary() {
        if let library {
            modelContext.delete(library)
            dismiss()
            onDismiss()
        }
    }

    private func saveLibrary() {
        guard let library, !self.title.isEmpty else {
            return
        }

        do {
            library.title = title
            library.date = .now
            try modelContext.save()
        } catch {
            print("Failed to save library: \(error.localizedDescription)")
        }

        dismiss()
    }
}
