//
//  LibraryView.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI

struct LibraryView: View {

    @Query var data: [SavedGame]
    
    @Environment(\.modelContext) private var context
    
    @AppStorage("collectionViewType") private var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white

    @State private var selectedLibraryType: LibraryType = .all
    @State private var searchQuery = ""
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            VStack {
                Header
                Spacer()
                ViewSwitcher
            }
            .background(.gray.opacity(0.15))
            .onChange(of: searchQuery, { oldValue, newValue in
                isSearching = !newValue.isEmpty
            })
            .onReceive(NotificationCenter.default.publisher(
                for: UIApplication.keyboardWillHideNotification), perform: { _ in
                isSearching = false
            })
        }
    }

    var savedGames: [SavedGame] {
        if selectedLibraryType == .all {
            return data
        } else {
            return data.filter({ $0.libraryType == selectedLibraryType.id })
        }
    }
    
    var filteredGames: [SavedGame] {
        return savedGames.filter { game in
            if let name = game.name {
                return name.lowercased().contains(searchQuery.lowercased())
            }
            
            return false
        }
    }
    
    private var Header: some View {
        HStack {
            LibraryPicker
            Spacer()
            ViewTypePicker
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private var LibraryPicker: some View {
        Menu {
            Picker("Library", selection: $selectedLibraryType) {
                ForEach(LibraryType.allCases, id: \.id) { library in
                    Text(library.title).tag(library)
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 4) {
                HStack(spacing: 8) {
                    SFImage(name: selectedLibraryType.selectedIconName, opacity: 0, radius: 0, padding: 0, color: appTint)
                    
                    Text(selectedLibraryType.title)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(.primary)
                        .shadow(radius: 10)
                }
                   
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
            }
            .hSpacing(.leading)
        }
    }
    
    private var ViewTypePicker: some View {
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
            }
            
        } label: {
            SFImage(name: viewType.imageName, color: appTint)
        } primaryAction: {
            viewType = viewType == .list ? .grid : .list
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
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    private var ListView: some View {
        if !savedGames.isEmpty {
            List {
                ForEach(isSearching ? filteredGames : savedGames, id: \.id) { game in
                    ListRowView(savedGame: game)
                        .id(game.id)
                        .navigationLink({
                            GameDetailView(savedGame: game)
                        })
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
    
    @ViewBuilder
    private var GridView: some View {
        if !savedGames.isEmpty {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                    ForEach(isSearching ? filteredGames : savedGames, id: \.id) { game in
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
