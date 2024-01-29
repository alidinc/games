//
//  CollectionView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI

struct GamesNetworkView: View {
    
    @Environment(GamesViewModel.self) private var vm
    
    @AppStorage("viewType") var viewType: ViewType = .list
    
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
            ForEach(vm.dataFetchPhase.value ?? [], id: \.id) { game in
                GameListItemView(game: game)
                    .navigationLink({
                        GameDetailView(game: game)
                    })
                    .task {
                        if self.vm.hasReachedEnd(of: game) {
                            await vm.fetchNextSetOfGames()
                        }
                    }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .padding(.bottom, vm.isFetchingNextPage ? 75 : 0)
        .overlay(alignment: .bottom, content: {
            if vm.isFetchingNextPage {
                ProgressView()
                    .controlSize(.large)
                    .padding(20)
            }
        })
    }
    
    private var GridView: some View {
        ScrollView(showsIndicators: false)  {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                ForEach(vm.dataFetchPhase.value ?? [], id: \.id) { game in
                    if let cover = game.cover, let url = cover.url {
                        NavigationLink {
                            GameDetailView(game: game)
                        } label: {
                            AsyncImageView(with: url, type: .grid)
                                .task {
                                    if vm.hasReachedEnd(of: game) {
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
        }
        .padding(.bottom, vm.isFetchingNextPage ? 75 : 0)
        .overlay(alignment: .bottom, content: {
            if vm.isFetchingNextPage {
                ProgressView()
                    .controlSize(.large)
                    .padding(20)
            }
        })
    }
}
