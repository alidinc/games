//
//  SavedCollectionView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftData
import SwiftUI

struct SavedCollectionView: View {
    
    @AppStorage("viewType") var viewType: ViewType = .list
    @Environment(Admin.self) private var admin: Admin
    @Environment(GamesViewModel.self) private var vm
    
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
            ForEach(vm.savedGames, id: \.id) { savedGame in
                if let game = savedGame.game {
                    switch admin.networkStatus {
                    case .available:
                        GameListItemView(game: game)
                            .navigationLink({
                                DetailView(game: game)
                            })
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                    case .unavailable:
                        GameListItemView(savedGame: savedGame)
                            .navigationLink {
                                DetailView(savedGame: savedGame)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
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
                ForEach(vm.savedGames, id: \.id) { savedGame in
                    switch admin.networkStatus {
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
                                let width = UIScreen.main.bounds.size.width / 3.3
                                let height = width * 1.32
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .shadow(color: .white.opacity(0.7), radius: 10)
                                    .frame(width: width, height: height)
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
