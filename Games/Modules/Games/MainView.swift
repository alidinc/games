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
    @Bindable var newsVM: NewsViewModel
    
    @Environment(\.colorScheme) private var scheme
    
    @State var count = 0
    @State var isTextFieldFocused: Bool = false
    @State var showSearch = false
    @State var contentType: ContentType = .games
    @State var libraryToEdit: Library?
    @State var showDeleteAlert = false
    @State var showAddLibrary = false
    @State var showEditLibrary = false
    @State var libraryToDelete: Library?
    
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
            .floatingBottomSheet(isPresented: $showAddLibrary) {
                SampleSheetView(title: "Add a new library",
                                image: .init(content: "tray",
                                             tint: appTint, foreground: .white)) {
                    AddLibraryView()
                }
                                             .presentationDetents([.height(350)])
            }
            .floatingBottomSheet(isPresented: $showEditLibrary) {
                SampleSheetView(title: "Edit library",
                                image: .init(content: "tray",
                                             tint: appTint, foreground: .white)) {
                    EditLibraryView(library: $libraryToEdit) {
                        self.libraryToEdit = nil
                    }
                }
                                             .presentationDetents([.height(350)])
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
        }
    }
}

extension MainView {
    
    var CountView: some View {
        VStack(spacing: 6) {
            Text(count, format: .number)
                .font(.system(size: 80))
                .fontWeight(.semibold)
                .contentTransition(.numericText())

            LibrariesMenu

            SubtitleInfo

        }
        .padding(.horizontal)
        .frame(height: UIScreen.main.bounds.height / 5)
        .onAppear {
            count = countOfSavedGames
        }
        .onChange(of: countOfSavedGames) { oldValue, newValue in
            withAnimation {
                count = newValue
            }
        }
    }

    private var countOfSavedGames: Int {
        if let libraryToEdit = libraryToEdit {
            return libraryToEdit.savedGames?.count ?? 0
        } else {
            return libraries.reduce(0) { $0 + ($1.savedGames?.count ?? 0) }
        }
    }

    @ViewBuilder
    private var SubtitleInfo: some View {
        Group {
            switch contentType {
            case .games:
                Text("Currently viewing results from database")
            case .news:
                Text("Currently viewing latest news")
            case .library:
                if let libraryToEdit {
                    Text("Currently viewing your \(libraryToEdit.title) library")
                } else {
                    Text("Currently viewing all of your libraries")
                }
            }
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    var ContentTypeView: some View {
        switch self.contentType {
        case .games:
            GamesCollectionView(games: vm.dataFetchPhase.value ?? [], contentType: .games, showAddLibrary: $showAddLibrary)
                .overlay(content: { GamesOverlayView() })
                .task(id: vm.fetchTaskToken) { await vm.fetchGames() }
        case .news:
            NewsTab(vm: newsVM)
        case .library:
            GamesCollectionView(games: filteredSavedGames.compactMap({ $0.game }), contentType: .library, showAddLibrary: $showAddLibrary)
                .opacity(filteredSavedGames.isEmpty ? 0 : 1)
                .overlay(alignment: .center) {
                    if vm.hasLibraryFilters {
                        UnavailableView(unavailableViewTitle, systemImage: "exclamationmark.triangle", action: vm.resetLibraryFilters)
                            .opacity(filteredSavedGames.isEmpty ? 1 : 0)
                    } else {
                        UnavailableView(unavailableViewTitle, systemImage: "exclamationmark.triangle", action: nil)
                            .opacity(filteredSavedGames.isEmpty ? 1 : 0)
                    }
                }
        }
    }
    
    var LibrariesMenu: some View {
        Menu {
            ForEach(libraries) { library in
                Button {
                    DispatchQueue.main.async {
                        self.libraryToEdit = library
                        self.contentType = .library
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
                DispatchQueue.main.async {
                    self.libraryToEdit = nil
                    self.contentType = .library
                }
            } label: {
                Label("Show all libraries", systemImage: "tray.full.fill")
            }
            
            Button {
                showAddLibrary = true
            } label: {
                Label("Add a new library", systemImage: "plus")
            }
            
        } label: {
            HStack {
                Text(libraryToEdit?.title ?? "All saved games")
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(1)

                Image(systemName: "chevron.down")
            }
            .multilineTextAlignment(.center)
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
            savedGamesToFilter = libraryToEdit.savedGames ?? []
        } else {
            savedGamesToFilter = libraries.flatMap { $0.savedGames ?? [] }
        }
        
        return savedGamesToFilter.filter { savedGame in
            let game = savedGame.game
            return matchesSelectedGenres(game) && matchesSelectedPlatforms(game)
        }
    }
    
    private func matchesSelectedGenres(_ game: Game?) -> Bool {
        return vm.selectedGenres.isEmpty || (game?.genres?.contains { genre in
            vm.selectedGenres.contains(genre.popularGenre)
        } ?? false)
    }
    
    private func matchesSelectedPlatforms(_ game: Game?) -> Bool {
        return vm.selectedPlatforms.isEmpty || (game?.platforms?.contains { platform in
            vm.selectedPlatforms.contains(platform.popularPlatform)
        } ?? false)
    }
    
    private var unavailableViewTitle: String {
        if !vm.selectedPlatforms.isEmpty && vm.selectedGenres.isEmpty {
            return "No games found for this criteria"
        } else if vm.selectedPlatforms.isEmpty && !vm.selectedGenres.isEmpty {
            return "No games found for this criteria"
        } else if !vm.selectedPlatforms.isEmpty && !vm.selectedGenres.isEmpty {
            return "No games found for this criteria"
        } else {
            return  "No saved games available."
        }
    }
}

extension MainView {
    
    var Header: some View {
        VStack {
            HStack(alignment: .center) {
                ContentTypePicker

                if libraryToEdit != nil {
                    Button {
                        showEditLibrary = true
                    } label: {
                        SFImage(
                            config: .init(
                                name:  "pencil.line",
                                padding: 10,
                                color: .primary
                            )
                        )
                    }
                }

                if contentType == .games {
                    SearchButton
                }

                Spacer()
                
                FiltersMenu(contentType: contentType, gamesVM: vm, newsVM: newsVM)
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
        .onChange(of: showSearch) { _, showSearch in
            if showSearch {
                contentType = .games
            } else  {
                if !vm.searchQuery.isEmpty {
                    vm.searchQuery = ""
                    Task {
                        await vm.refreshTask()
                    }
                }
            }
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
    
    var ContentTypePicker: some View {
        Menu {
            ForEach(ContentType.allCases) { type in
                Button {
                    self.contentType = type
                    self.libraryToEdit = nil
                } label: {
                    Label(type.title, systemImage: type.imageName)
                }
            }
        } label: {
            SFImage(
                config: .init(
                    name:  contentType.imageName,
                    padding: 10,
                    color: .primary
                )
            )
        }
        .font(.subheadline)
        .fontWeight(.medium)
    }
}
