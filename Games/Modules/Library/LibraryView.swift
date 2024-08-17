//
//  LibraryView.swift
//  Games
//
//  Created by Ali Dinç on 17/08/2024.
//

import SwiftUI

struct LibraryView: View {

    let library: Library

    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        NavigationStack {
            VStack {
                ImageView

                VStack(alignment: .center, spacing: 8) {
                    Text(library.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .multilineTextAlignment(.center)

                    if let subtitle = library.subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(appTint)
                            .multilineTextAlignment(.center)
                    }

                    Text(library.date, format: .dateTime.year().month(.wide).day())
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                if let savedGames = library.savedGames {
                    List {
                        ForEach(savedGames) { data in
                            if let game = data.game, let name = game.name {
                                Text(name)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CloseButton()
                }
            }
        }
    }

    @ViewBuilder
    private var ImageView: some View {
        if let imageData = library.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .foregroundStyle(.gray)
                .cornerRadius(10)

        } else {
            Image(scheme == .dark ? .icon5 : .icon1)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundStyle(.gray)
                .cornerRadius(10)

        }
    }
}
