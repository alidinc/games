//
//  GameCardsView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct GameCardsView: View {
    
    var vm: HomeViewModel
    @State private var hasReachedEnd = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 120) {
                ForEach(vm.games, id: \.id) { game in
                    NavigationLink {
                        GameDetailView(game: game)
                    } label: {
                        CardView(game: game)
                            .scrollTransition { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                    .rotationEffect(.degrees(phase.isIdentity ? 0 : -30))
                                    .rotation3DEffect(.degrees(phase.isIdentity ? 0 : 60), axis: (x: -1, y: 1, z: 0))
                                    .blur(radius: phase.isIdentity ? 0 : 60)
                                    .offset(x: phase.isIdentity ? 0 : -200)
                            }
                            .padding(.top, 20)
                            .task {
                                hasReachedEnd = vm.hasReachedEnd(of: game)
                            }
                            .contentShape(.rect)
                    }
                }
            }
            .scrollTargetLayout()
            .task(id: hasReachedEnd) {
                await vm.fetchNextSetOfGames()
            }
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
        .scrollTargetBehavior(.viewAligned)
    }
}
