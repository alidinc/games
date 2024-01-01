//
//  GameGridView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct GameGridView: View {
    
    var vm: HomeViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
