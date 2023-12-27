//
//  GameListView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct GameListView: View {
    
    var vm: HomeViewModel
    
    @State private var hasReachedEnd = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.games, id: \.id) { game in
                    NavigationLink {
                        GameDetailView(game: game)
                    } label: {
                        ListRowView(game: game)
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
