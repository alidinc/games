//
//  SavedCollectionView.swift
//  Gametrack
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftData
import SwiftUI

struct SavedCollectionView: View {
    
    var games: [SavedGame]
    @Binding var viewType: ViewType
    
    var body: some View {
        switch viewType {
        case .list:
            ListView
        case .grid:
            GridView
        }
    }
    
    @MainActor
    @ViewBuilder
    private var ListView: some View {
        List {
            ForEach(games, id: \.id) { game in
                ListRowView(savedGame: game)
                    .navigationLink({
                        GameDetailView(savedGame: game)
                    })
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    @MainActor
    private var GridView: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                ForEach(games, id: \.id) { game in
                    if let cover = game.cover, let url = cover.url {
                        NavigationLink {
                            GameDetailView(savedGame: game)
                        } label: {
                            AsyncImageView(with: url, type: .grid)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}
