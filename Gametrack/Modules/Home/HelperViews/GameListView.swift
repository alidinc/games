//
//  GameListView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct GameListView: View {
    
    var vm: HomeViewModel
    
    var body: some View {
        List {
            ForEach(vm.games, id: \.id) { game in
                ListRowView(game: game)
                    .id(game.id)
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
            .padding(.horizontal)
        }
        .listStyle(.plain)
        .padding(.top)
        .padding(.bottom, 1)
        
    }
}
