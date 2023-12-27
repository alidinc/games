//
//  GameGridView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct GameGridView: View {
    
    var vm: HomeViewModel
    @State private var hasReachedEnd = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                ForEach(vm.games, id: \.id) { game in
                    if let cover = game.cover, let url = cover.url {
                        NavigationLink {
                            GameDetailView(game: game)
                        } label: {
                            AsyncImageView(with: url, type: .grid)
                                .task {
                                    if self.vm.hasReachedEnd(of: game) {
                                        await vm.fetchNextSetOfGames()
                                    }
                                }
                                .task {
                                    if vm.hasReachedEnd(of: game) {
                                        hasReachedEnd = true
                                    }
                                }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .padding(.horizontal)
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
        .padding(.top)
        .padding(.bottom, 1)
    }
}
