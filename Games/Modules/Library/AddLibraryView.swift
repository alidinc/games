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

    @State private var title: String = ""
    @State private var date: Date = Date()

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Enter Library Title", text: $title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)


                Text(Date.now, format: .dateTime.year().month(.wide).day())
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.leading)

            Spacer()

            Button(action: saveLibrary) {
                Text("Save")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("\(library == nil ? "Add" : "Edit") Library")
        .padding()
        .presentationDetents([.fraction(0.65)])
        .onAppear {
            if let library {
                title = library.title
                date = library.date
            }
        }
    }

    private func saveLibrary() {
        if let library {
            DispatchQueue.main.async {
                library.title = self.title
                library.date = self.date

            }

            do {
                try modelContext.save()
            } catch {

            }
            
        } else {
            let newLibrary = Library(title: title)
            modelContext.insert(newLibrary)
        }

        dismiss()
    }
}
