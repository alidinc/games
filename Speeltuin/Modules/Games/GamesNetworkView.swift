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
    
    @State var scrollingItem = 0
    
    var body: some View {
        switch viewType {
        case .list:
            ListView
        case .grid:
            GridView
        }
    }
    
    private var ListView: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(vm.dataFetchPhase.value ?? [], id: \.id) { game in
                    NavigationLink(value: game) {
                        GameListItemView(game: game)
                    }
                        .id(vm.dataFetchPhase.value?.first)
                        .task {
                            if self.vm.hasReachedEnd(of: game) {
                                await vm.fetchNextSetOfGames()
                            }
                        }
                        .if(vm.dataFetchPhase.value?.last == game) { view in
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
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .onReselect {
                withAnimation {
                    proxy.scrollTo(vm.dataFetchPhase.value?.first, anchor: .top)
                }
            }
            .navigationDestination(for: Game.self) { game in
                GameDetailView(game: game)
            }
        }
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
