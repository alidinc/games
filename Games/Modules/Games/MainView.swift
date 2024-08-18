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

    @Bindable var vm: GamesViewModel

    @Environment(\.colorScheme) private var scheme

    @State var newsVM = NewsViewModel()
    @State var isTextFieldFocused: Bool = false
    @State var showSearch = false
    @State var contentType: ContentType = .games
    @State var libraryToEdit: Library?
    @State var selectedPlatforms: Set<PopularPlatform> = []
    @State var selectedGenres: Set<PopularGenre> = []
    @State var showDeleteAlert = false
    @State var showAddLibrary = false
    @State var libraryToDelete: Library?

    @State var librariesMenuTitle: String = "All saved games"

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
            .onChange(of: showSearch) { _, newValue in
                isTextFieldFocused = newValue
            }
            .onChange(of: libraryToEdit) { _,newLibrary in
                librariesMenuTitle = newLibrary?.title ?? "All saved games"
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MoreTab()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .floatingBottomSheet(isPresented: $showAddLibrary) {
                SampleSheetView(title: "Add a new library",
                                image: .init(content: "folder.fill.badge.plus",
                                             tint: appTint, foreground: .white)) {
                    AddLibraryView { library in
                        self.libraryToEdit = library
                    }
                }
                .presentationDetents([.height(350)])
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
                    DispatchQueue.main.async {
                        self.contentType = .library
                        self.libraryToEdit = library
                    }
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
            VStack(alignment: .center, spacing: 2) {
                HStack {
                    Text(librariesMenuTitle)
                        .font(.title2)
                        .fontWeight(.bold)

                    Image(systemName: "chevron.down")
                }

                Text(libraryToEdit?.date ?? Date.now, format: .dateTime.year().month(.wide).day())
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
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
        // Determine which saved games to filter based on whether a specific library is selected
        let savedGamesToFilter: [SavedGame]

        if let libraryToEdit = libraryToEdit {
            // Filter saved games in the selected library
            savedGamesToFilter = libraryToEdit.savedGames ?? []
        } else {
            // No specific library selected, collect saved games from all libraries
            savedGamesToFilter = libraries.flatMap { $0.savedGames ?? [] }
        }

        // Apply the genre and platform filters
        return savedGamesToFilter.filter { savedGame in
            let game = savedGame.game
            return matchesSelectedGenres(game) && matchesSelectedPlatforms(game)
        }
    }

    private func matchesSelectedGenres(_ game: Game?) -> Bool {
        // Check if game matches selected genres
        return selectedGenres.isEmpty || (game?.genres?.contains { genre in
            selectedGenres.contains(genre.popularGenre)
        } ?? false)
    }

    private func matchesSelectedPlatforms(_ game: Game?) -> Bool {
        // Check if game matches selected platforms
        return selectedPlatforms.isEmpty || (game?.platforms?.contains { platform in
            selectedPlatforms.contains(platform.popularPlatform)
        } ?? false)
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
    }
}

extension MainView {

    var Header: some View {
        VStack {
            HStack(alignment: .center) {
                MultiPicker
                if contentType == .games {
                    SearchButton
                }
                Spacer()
                FiltersButton
            }

            if showSearch {
                SearchTextField(
                    searchQuery: $vm.searchQuery,
                    prompt: vm.searchPlaceholder,
                    isFocused: $isTextFieldFocused
                )
            }
        }
        .labelStyle()
        .padding(.horizontal)
    }

    var FiltersButton: some View {
        Menu {
            switch contentType {
            case .games:
                Menu {
                    ForEach(Category.allCases) { category in
                        Button(category.title, systemImage: category.systemImage) {
                            vm.categorySelected(for: category)
                        }
                    }
                } label: {
                    Text("Category")
                }

                Divider()

                Menu {
                    let platforms = PopularPlatform.allCases.filter({$0 != PopularPlatform.database }).sorted(by: { $0.title < $1.title })

                    ForEach(platforms) { platform in
                        Button {
                            if hapticsEnabled {
                                HapticsManager.shared.vibrateForSelection()
                            }
                            vm.togglePlatform(platform)
                        } label: {
                            HStack {
                                Text(platform.title)
                                if vm.fetchTaskToken.platforms.contains(platform) {
                                    Image(systemName: "checkmark")
                                }
                                Image(platform.assetName)
                            }
                        }
                    }
                } label: {
                    Text("Platform")
                }

                Divider()

                Menu {
                    let genres = PopularGenre.allCases.filter({$0 != PopularGenre.allGenres }).sorted(by: { $0.title < $1.title })

                    ForEach(genres) { genre in
                        Button {
                            if hapticsEnabled {
                                HapticsManager.shared.vibrateForSelection()
                            }

                            vm.toggleGenre(genre)
                        } label: {
                            HStack {
                                Text(genre.title)
                                if vm.fetchTaskToken.genres.contains(genre) {
                                    Image(systemName: "checkmark")
                                }
                                Image(genre.assetName)
                            }
                        }
                    }
                } label: {
                    Text("Genre")
                }

                Divider()

                Button(role: .destructive) {
                    vm.fetchTaskToken.platforms = [.database]
                    vm.fetchTaskToken.genres = [.allGenres]
                    Task {
                        await vm.refreshTask()
                    }
                } label: {
                    Text("Remove filters")
                }

            case .news:
                ForEach(NewsType.allCases) { news in
                    Button {
                        newsVM.newsType = news
                    } label: {
                        Text(news.title)
                    }
                }
            case .library:
                Menu {
                    let genres = PopularGenre.allCases.filter({$0 != PopularGenre.allGenres }).sorted(by: { $0.title < $1.title })

                    ForEach(genres) { genre in
                        Button {
                            if hapticsEnabled {
                                HapticsManager.shared.vibrateForSelection()
                            }

                            if !self.selectedGenres.contains(genre) {
                                self.selectedGenres.insert(genre)
                            } else {
                                self.selectedGenres.remove(genre)
                            }
                        } label: {
                            HStack {
                                Text(genre.title)
                                if self.selectedGenres.contains(genre) {
                                    Image(systemName: "checkmark")
                                }
                                Image(genre.assetName)
                            }
                        }
                    }
                } label: {
                    Text("Genre")
                }

                Menu {
                    let platforms = PopularPlatform.allCases.filter({$0 != PopularPlatform.database }).sorted(by: { $0.title < $1.title })

                    ForEach(platforms) { platform in
                        Button {
                            if hapticsEnabled {
                                HapticsManager.shared.vibrateForSelection()
                            }

                            if !self.selectedPlatforms.contains(platform) {
                                self.selectedPlatforms.insert(platform)
                            } else {
                                self.selectedPlatforms.remove(platform)
                            }
                        } label: {
                            HStack {
                                Text(platform.title)
                                if vm.fetchTaskToken.platforms.contains(platform) {
                                    Image(systemName: "checkmark")
                                }
                                Image(platform.assetName)
                            }
                        }
                    }
                } label: {
                    Text("Platform")
                }


                Button(role: .destructive) {
                    self.selectedGenres = []
                    self.selectedPlatforms = []
                } label: {
                    Text("Remove filters")
                }
            }
        } label: {
            SFImage(
                config: .init(
                    name: "slider.horizontal.3",
                    padding: 10,
                    color: hasFilters ? appTint : .primary
                )
            )
        }
        .animation(.bouncy, value: vm.hasFilters)
    }

    var hasFilters: Bool {
        if contentType == .games {
            return !(self.vm.fetchTaskToken.platforms.contains(.database) && self.vm.fetchTaskToken.platforms.count == 1 ) ||
                    !(self.vm.fetchTaskToken.genres.contains(.allGenres) && self.vm.fetchTaskToken.genres.count == 1)
        } else if contentType == .library {
            return !self.selectedGenres.isEmpty || !self.selectedPlatforms.isEmpty
        } else {
            return false
        }
    }

    var SearchButton: some View {
        Button {
            withAnimation(.bouncy) {
                showSearch.toggle()
            }

            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        } label: {
            SFImage(
                config: .init(
                    name: "magnifyingglass",
                    padding: 10,
                    color: .primary
                )
            )
        }
        .transition(.move(edge: .top))
    }

    var MultiPicker: some View {
        Menu {
            ForEach(ContentType.allCases) { type in
                Button {
                    self.contentType = type
                } label: {
                    Label(type.title, systemImage: type.imageName)
                }
            }
        } label: {
            Image(systemName: self.contentType.imageName)
        }
        .font(.subheadline)
        .fontWeight(.medium)
    }
}
