//
//  CollectionView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI

struct GamesCollectionView: View {

    let games: [Game]
    let contentType: ContentType
    @Binding var showAddLibrary: Bool

    @Environment(GamesViewModel.self) private var vm
    @AppStorage("viewType") var viewType: ViewType = .grid

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
            ForEach(games, id: \.id) { game in
                ListItemView(game: game, showAddLibrary: $showAddLibrary)
                    .navigationLink({
                        GameDetailView(game: game, showAddLibrary: $showAddLibrary)
                    })
                    .task {
                        if self.vm.hasReachedEnd(of: game) {
                            await vm.fetchNextSetOfGames()
                        }
                    }
                    .if(vm.hasReachedEnd(of: game) && contentType == .games) { view in
                        view
                            .padding(.bottom, 100)
                            .overlay(alignment: .bottom) {
                                ZStack(alignment: .center) {
                                    ProgressView()
                                        .controlSize(.large)
                                }
                                .hSpacing(.center)
                                .frame(height: 100)
                            }
                    }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private var GridView: some View {
        ScrollView(showsIndicators: false)  {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                ForEach(games, id: \.id) { game in
                    if let cover = game.cover, let url = cover.url {
                        NavigationLink {
                            GameDetailView(game: game, showAddLibrary: $showAddLibrary)
                        } label: {
                            AsyncImageView(with: url, type: .grid)
                                .task {
                                    if vm.hasReachedEnd(of: game) && contentType == .games {
                                        await vm.fetchNextSetOfGames()
                                    }
                                }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .padding(.horizontal, 10)
            .if(vm.isFetchingNextPage) { view in
                view
                    .padding(.bottom, 100)
                    .overlay(alignment: .bottom) {
                        ZStack(alignment: .center) {
                            ProgressView()
                                .controlSize(.large)
                        }
                        .hSpacing(.center)
                        .frame(height: 100)
                    }
            }
        }
    }
}
