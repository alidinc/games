//
//  AddLibraryView.swift
//  Games
//
//  Created by Ali Dinç on 17/08/2024.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddLibraryView: View {

    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var date: Date = Date()
    @State private var imageData: Data?
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                    .padding()
            } else {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    VStack {
                        Image(scheme == .dark ? .icon5 : .icon1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .padding()
                        Text("Select Image")
                    }
                }
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            imageData = data
                        }
                    }
                }
            }

            VStack(alignment: .center, spacing: 8) {
                TextField("Enter Library Title", text: $title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .multilineTextAlignment(.center)

                TextField("Enter Description", text: $subtitle, axis: .vertical)
                    .font(.title3)
                    .foregroundStyle(appTint)
                    .multilineTextAlignment(.center)

                Text(Date.now, format: .dateTime.year().month(.wide).day())
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

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
        .navigationTitle("Add Library")
        .padding()
    }

    private func saveLibrary() {
        let newLibrary = Library(title: title, subtitle: subtitle, imageData: imageData)
        modelContext.insert(newLibrary)
        dismiss()
    }
}


struct TrackRow: View {
    let trackNumber: String
    let trackTitle: String
    var explicit: Bool = false

    var body: some View {
        HStack {
            Text(trackNumber)
                .font(.body)
                .foregroundColor(.gray)

            Text(trackTitle)
                .font(.body)
                .fontWeight(.regular)

            if explicit {
                Image(systemName: "e.square.fill")
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
}
