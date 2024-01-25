//
//  SavedCollectionView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftData
import SwiftUI

struct SavedCollectionView: View {
    
    var games: [SavedGame]
    @AppStorage("viewType") var viewType: ViewType = .list
    @Environment(Admin.self) private var preferences: Admin
    
    var body: some View {
        switch viewType {
        case .list:
            ListView
        case .grid:
            GridView
        }
    }
    
    private var ListView: some View {
        List {
            ForEach(games, id: \.id) { savedGame in
                if let game = savedGame.game {
                    switch preferences.networkStatus {
                    case .available:
                        GameListItemView(game: game)
                            .navigationLink({
                                DetailView(game: game)
                            })
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                    case .unavailable:
                        GameListItemView(savedGame: savedGame)
                            .navigationLink {
                                DetailView(savedGame: savedGame)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    private var GridView: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                ForEach(games, id: \.id) { savedGame in
                    switch preferences.networkStatus {
                    case .available:
                        if let game = savedGame.game, let cover = game.cover, let url = cover.url {
                            NavigationLink {
                                DetailView(game: game)
                            } label: {
                                AsyncImageView(with: url, type: .grid)
                            }
                        }
                    case .unavailable:
                        if let imageData = savedGame.imageData, let uiImage = UIImage(data: imageData)  {
                            NavigationLink(destination: {
                                DetailView(savedGame: savedGame)
                            }, label: {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .shadow(color: .white.opacity(0.7), radius: 10)
                                    .frame(width: 120, height: 160)
                                    .clipShape(.rect(cornerRadius: 5))
                            })
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}
