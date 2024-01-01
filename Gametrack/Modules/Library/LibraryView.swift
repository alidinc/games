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
    
    @State private var searchQuery = ""
    
    @State private var isFirstTime = true
    
    @State private var isSearching = false

    
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
            .onChange(of: searchQuery, { oldValue, newValue in
                isSearching = !newValue.isEmpty
            })
            .onAppear {
                if isFirstTime {
                    if !libraries.isEmpty, let richOne = libraries.max(by: { $0.savedGames.count < $1.savedGames.count }) {
                        selectedLibrary = richOne
                        isFirstTime = false
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification), perform: { _ in
                isSearching = false
            })
        }
    }

    var games: [SavedGame] {
        if let library = libraries.first(where: { $0.id == selectedLibrary.id }) {
            return library.savedGames
        }
        
        return []
    }
    
    var filteredGames: [SavedGame] {
        if let library = libraries.first(where: { $0.id == selectedLibrary.id }) {
            return library.savedGames.filter { game in
                return game.name.lowercased().contains(searchQuery.lowercased())
            }
        }
        
        return []
    }
    
    private var ListView: some View {
        VStack {
            if !games.isEmpty {
                List {
                    ForEach(isSearching ? filteredGames : games, id: \.id) { game in
                        ListRowView(savedGame: game)
                            .navigationLink({
                                GameDetailView(savedGame: game)
                            })
                            .id(game.id)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .overlay {
                    if isSearching && filteredGames.isEmpty {
                        ContentUnavailableView.search(text: searchQuery)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No content found in your library",
                    systemImage: "gamecontroller.fill",
                    description: Text(
                        "Please add some games to your library."
                    )
                )
            }
        }
    }
    
    private var GridView: some View {
        VStack {
            if !games.isEmpty {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                        ForEach(isSearching ? filteredGames : games, id: \.id) { game in
                            if let url = game.cover.url {
                                NavigationLink {
                                    GameDetailView(savedGame: game)
                                } label: {
                                    AsyncImageView(with: url, type: .grid)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                .overlay {
                    if isSearching && filteredGames.isEmpty{
                        ContentUnavailableView.search(text: searchQuery)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No content found in your library",
                    systemImage: "gamecontroller.fill",
                    description: Text(
                        "Please add some games to your library."
                    )
                )
            }
        }
    }
    
    
    @ViewBuilder
    var ViewSwitcher: some View {
        ZStack {
            VStack(spacing: 10) {
                SearchTextField(searchQuery: $searchQuery)
                switch viewType {
                case .list:
                    ListView
                case .grid:
                    GridView
                case .card:
                    EmptyView()
                    Spacer()
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 10))
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
            Menu {
                Section("View type") {
                    Button {
                        viewType = .list
                    } label: {
                        Image(systemName: "rectangle.grid.1x2.fill")
                        Text("List")
                    }
                    
                    Button {
                        viewType = .grid
                    } label: {
                        Image(systemName: "rectangle.grid.3x2.fill")
                        Text("Grid")
                    }
                    
                    Button {
                        viewType = .card
                    } label: {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                        Text("Card")
                    }
                }
                
            } label: {
                SFImage(name: viewType.imageName)
            } primaryAction: {
                if viewType == .list {
                    viewType = .grid
                } else if viewType == .grid {
                    viewType = .card
                } else if viewType == .card {
                    viewType = .list
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
