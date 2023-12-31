//
//  LibraryView.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI

struct LibraryView: View {
    
    @Query var libraries: [Library]
    
    @State private var selectedLibrary: Library = Library(id: "123", name: "Wishlist")
    
    @Environment(\.modelContext) private var context
    
    @AppStorage("collectionViewType") private var viewType: ViewType = .list
    
    @State private var isFirstTime = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                Spacer()
                
                ViewSwitcher
            }
            .background(.gray.opacity(0.15))
            .onChange(of: libraries) { oldValue, newValue in
                if newValue.count == 1 {
                    if let newLibrary = newValue.first {
                        selectedLibrary = newLibrary
                    }
                }
            }
            .onAppear {
                if isFirstTime {
                    if !libraries.isEmpty, let richOne = libraries.max(by: { $0.games.count < $1.games.count }) {
                        selectedLibrary = richOne
                        isFirstTime = false
                    }
                }
            }
        }
    }

    var games: [SavedGame] {
        if let library = libraries.first(where: { $0.id == selectedLibrary.id }) {
            return library.games
        }
        
        return []
    }
    
    @ViewBuilder
    var ViewSwitcher: some View {
        ZStack {
            switch viewType {
            case .list:
                List {
                    ForEach(games, id: \.id) { game in
                        ListRowView(savedGame: game)
                            .navigationLink({
                                GameDetailView(savedGame: game)
                            })
                            .id(game.id)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                    }
                    .padding(.horizontal)
                }
                .listStyle(.plain)
            case .grid:
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                        ForEach(games, id: \.id) { game in
                            if let cover = game.cover, let url = cover.url {
                                NavigationLink {
                                    GameDetailView(savedGame: game)
                                } label: {
                                    AsyncImageView(with: url, type: .grid)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal)
                }
                .padding(.top)
                .padding(.bottom, 1)
            case .card:
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 120) {
                            ForEach(games, id: \.id) { game in
                                NavigationLink {
                                    GameDetailView(savedGame: game)
                                } label: {
                                    CardView(savedGame: game)
                                        .scrollTransition { content, phase in
                                            content
                                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                                .rotationEffect(.degrees(phase.isIdentity ? 0 : -30))
                                                .rotation3DEffect(.degrees(phase.isIdentity ? 0 : 60), axis: (x: -1, y: 1, z: 0))
                                                .blur(radius: phase.isIdentity ? 0 : 60)
                                                .offset(x: phase.isIdentity ? 0 : -200)
                                        }
                                        .padding(.top, 20)
                                        .contentShape(.rect)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .padding(.top, 1)
                    .padding(.bottom, 1)
            }
        }
        .padding(.top, 20)
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
        .padding(.bottom, 5)
    }
    
    private var Header: some View {
        HStack {
            Menu {
                Picker("Library", selection: $selectedLibrary) {
                    ForEach(libraries, id: \.id) { library in
                        Text(library.name).tag(library)
                    }
                }
            } label: {
                HStack(alignment: .center, spacing: 4) {
                    Text(selectedLibrary.name)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(.primary)
                        .shadow(radius: 10)
                       
                    Image(systemName: "chevron.down")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.primary)
                }
                .hSpacing(.leading)
            }
            
            AddLibraryButton()
            ViewTypeButton()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
