//
//  GamesTab.swift
//  Speeltuin
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftData
import SwiftUI
import Combine

struct MainView: View {

    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("viewType") var viewType: ViewType = .grid
    @AppStorage("appTint") var appTint: Color = .blue

    @Environment(\.colorScheme) private var scheme

    @State var newsVM = NewsViewModel()
    @Bindable var vm: GamesViewModel
    @State var isTextFieldFocused: Bool = false
    @State var showSearch = false
    @State var contentType: ContentType = .games

    @State var libraryToEdit: Library?
    @State var selectedPlatforms: Set<PopularPlatform> = []
    @State var selectedGenres: Set<PopularGenre> = []

    @State private var showDeleteAlert = false
    @State private var showAddLibrary = false
    @State private var libraryToDelete: Library?

    @Query var savedGames: [SavedGame]
    @Query var libraries: [Library]

    private var gradientColors: [Color] {
        let label = scheme == .dark ? Color.black : Color.white.opacity(0.15)
        return [label, appTint.opacity(0.45)]
    }

    var body: some View {
        NavigationStack {
            VStack {
                CountView
                Header
                ContentTypeView
            }
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .toolbarBackground(.hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom))
            .onChange(of: vm.searchQuery) { _, newValue in
                
            }
            .onChange(of: showSearch) { oldValue, newValue in
                isTextFieldFocused = newValue
            }
            .sheet(isPresented: $showAddLibrary, content: {
                AddLibraryView(library: nil)
            })
            .onChange(of: contentType, { _,_ in
                self.libraryToEdit = nil
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MoreTab()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
    }
}

extension MainView {

    var CountView: some View {
        VStack(spacing: 6) {
            Text(self.countOfSavedGames, format: .number)
                .font(.system(size: 80))
                .fontWeight(.semibold)
                .contentTransition(.numericText())

            LibrariesMenu
        }
        .frame(height: UIScreen.main.bounds.height / 5)
    }

    // Computed property to get the count of saved games based on the content type and selected library
    private var countOfSavedGames: Int {
        if let libraryToEdit = libraryToEdit, contentType == .library {
            return libraryToEdit.savedGames?.count ?? 0
        } else {
            return libraries.reduce(0) { $0 + ($1.savedGames?.count ?? 0) }
        }
    }

    @ViewBuilder
    var ContentTypeView: some View {
        switch self.contentType {
        case .games:
            GamesCollectionView()
                .overlay(content: { GamesOverlayView() })
                .task(id: vm.fetchTaskToken) { await vm.fetchGames() }
                .refreshable { await vm.refreshTask() }
        case .news:
            NewsTab(vm: newsVM)
        case .library:
            LibraryView()
        }
    }

    var LibrariesMenu: some View {
        Menu {
            ForEach(libraries) { library in
                Button {
                    self.libraryToEdit = library
                    self.contentType = .library
                } label: {
                    HStack {
                        Text(library.title)
                            .font(.body)
                            .fontWeight(.regular)

                        if let savedGames = library.savedGames {
                            Text(savedGames.count, format: .number)
                                .font(.body)
                                .fontWeight(.medium)
                                .padding(.trailing)
                        }
                    }
                }
            }

            Divider()

            Button {
                self.libraryToEdit = nil
                self.contentType = .library
            } label: {
                Label("Show all saved games", systemImage: "tray.full.fill")
            }

            Button {
                showAddLibrary = true
            } label: {
                Label("Add a new library", systemImage: "plus")
            }

        } label: {
            if let library = libraryToEdit {
                VStack(alignment: .center, spacing: 2) {
                    Text(library.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(library.date, format: .dateTime.year().month(.wide).day())
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            } else {
                VStack(alignment: .center, spacing: 2) {
                    Text("All saved games")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(Date.now, format: .dateTime.year().month(.wide).day())
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
        }
    }

    private func deleteLibrary(at offsets: IndexSet) {
        for index in offsets {
            let library = libraries[index]
            self.libraryToDelete = library
            self.showDeleteAlert = true
        }
    }

    private var filteredSavedGames: [SavedGame] {
        // Check if a specific library is selected
        if let libraryToEdit = libraryToEdit {
            // Filter saved games in the selected library
            return (libraryToEdit.savedGames ?? []).filter { savedGame in
                let game = savedGame.game

                // Check if game matches selected genres
                let matchesGenre = selectedGenres.isEmpty || (game?.genres?.contains { genre in
                    selectedGenres.contains(genre.popularGenre)
                } ?? false)

                // Check if game matches selected platforms
                let matchesPlatform = selectedPlatforms.isEmpty || (game?.platforms?.contains { platform in
                    selectedPlatforms.contains(platform.popularPlatform)
                } ?? false)

                return matchesGenre && matchesPlatform
            }
        } else {
            // No specific library selected, apply filters to all libraries
            return libraries.flatMap { library in
                (library.savedGames ?? []).filter { savedGame in
                    let game = savedGame.game

                    let matchesGenre = selectedGenres.isEmpty || (game?.genres?.contains { genre in
                        selectedGenres.contains(genre.popularGenre)
                    } ?? false)

                    let matchesPlatform = selectedPlatforms.isEmpty || (game?.platforms?.contains { platform in
                        selectedPlatforms.contains(platform.popularPlatform)
                    } ?? false)

                    return matchesGenre && matchesPlatform
                }
            }
        }
    }

    @ViewBuilder
    func LibraryView() -> some View {
        List {
            ForEach(filteredSavedGames) { savedGame in
                ListItemView(game: savedGame.game)
                    .navigationLink({
                        GameDetailView(savedGame: savedGame)
                    })
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .padding(.vertical, 12)
    }
}

