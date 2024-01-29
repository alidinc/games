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
    
    let dataManager: DataManager
    
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
                GameListItemView(game: game, dataManager: dataManager)
                    .navigationLink({
                        GameDetailView(game: game, dataManager: dataManager)
                    })
                    .task {
                        if self.vm.hasReachedEnd(of: game) {
                            await vm.fetchNextSetOfGames()
                        }
                    }
                    .if(vm.hasReachedEnd(of: game)) { view in
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
    }
    
    private var GridView: some View {
        ScrollView(showsIndicators: false)  {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                ForEach(vm.dataFetchPhase.value ?? [], id: \.id) { game in
                    if let cover = game.cover, let url = cover.url {
                        NavigationLink {
                            GameDetailView(game: game, dataManager: dataManager)
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
