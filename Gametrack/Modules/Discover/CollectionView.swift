//
//  CollectionView.swift
//  Gametrack
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI

struct CollectionView: View {
    
    var vm: DiscoverViewModel
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
            ForEach(vm.games, id: \.id) { game in
                EmptyView()
                    .navigationLink({
                        GameDetailView(game: game)
                    })
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .task {
                        if self.vm.hasReachedEnd(of: game) {
                            await vm.fetchNextSetOfGames()
                        }
                    }
                    .if(vm.games.last == game) { view in
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
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    @MainActor
    @ViewBuilder
    private var GridView: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                ForEach(vm.games, id: \.id) { game in
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
            .scrollContentBackground(.hidden)
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
