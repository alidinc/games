//
//  SPGamesCollectionView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftData
import SwiftUI

struct SPGamesCollectionView: View {
    
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
                        ListItemView(game: game)
                            .navigationLink({
                                GameDetailView(savedGame: savedGame)
                            })
                    case .unavailable:
                        ListItemView(savedGame: savedGame)
                            .navigationLink {
                                GameDetailView(savedGame: savedGame)
                            }
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
        }
        .id(vm.savedGamesListId)
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
    
    private var GridView: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                ForEach(vm.savedGames, id: \.id) { savedGame in
                    switch admin.networkStatus {
                    case .available:
                        if let game = savedGame.game, let cover = game.cover, let url = cover.url {
                            NavigationLink {
                                GameDetailView(savedGame: savedGame)
                            } label: {
                                AsyncImageView(with: url, type: .grid)
                            }
                        }
                    case .unavailable:
                        if let imageData = savedGame.imageData, let uiImage = UIImage(data: imageData)  {
                            NavigationLink(destination: {
                                GameDetailView(savedGame: savedGame)
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
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .padding(.horizontal, 10)
        }
        .id(vm.savedGamesListId)
    }
}
