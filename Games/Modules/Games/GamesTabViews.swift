//
//  GamesTabViews.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI

extension MainView {
    
    @ViewBuilder
    var ViewSwitcher: some View {
        switch vm.dataType {
        case .network:
            GamesCollectionView()
                .overlay { GamesOverlayView() }
                .refreshable {
                    await vm.refreshTask()
                }
        case .library:
            SPGamesCollectionView()
                .overlay { GamesOverlayView() }
                .id(vm.savedGamesListId)
        }
    }
    
    var Header: some View {
        VStack {
            HStack(alignment: .center) {
                MultiPicker
                Spacer()
                HStack(alignment: .bottom, spacing: 4) {
                    if contentType == .games {
                        SearchButton
                    }
                    FiltersButton
                    LibraryButton
                }
            }

            if showSearch {
                SearchTextField(
                    searchQuery: $vm.searchQuery,
                    prompt: vm.searchPlaceholder,
                    isFocused: $isTextFieldFocused
                )
            }
        }
        .padding(.horizontal)
    }
    
    var LibraryButton: some View {
        NavigationLink {
            LibraryView()
        } label: {
            SFImage(

                config: .init(
                    name: "tray.full.fill",
                    padding: 10,
                    color: .secondary
                )
            )
        }
    }
    
    var FiltersButton: some View {
        Menu {
            switch contentType {
            case .games:
                Menu {
                    let platforms = PopularPlatform.allCases.filter({$0 != PopularPlatform.database }).sorted(by: { $0.title < $1.title })

                    ForEach(platforms) { platform in
                        Button {
                            if hapticsEnabled {
                                HapticsManager.shared.vibrateForSelection()
                            }
                            vm.togglePlatform(platform, selectedLibrary: vm.selectedLibrary, savedGames: savedGames)
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
                            vm.toggleGenre(genre, selectedLibrary: vm.selectedLibrary, savedGames: savedGames)
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

                Button(role: .destructive) {
                    vm.fetchTaskToken.platforms = []
                    vm.fetchTaskToken.genres = []
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
            }
        } label: {
            switch contentType {
            case .games:
                SFImage(
                    config: .init(
                        name: "slider.horizontal.3",
                        padding: 10,
                        color: vm.hasFilters ? appTint : .secondary
                    )
                )
            case .news:
                SFImage(
                    config: .init(
                        name: "slider.horizontal.3",
                        padding: 10,
                        color: vm.hasFilters ? appTint : .secondary
                    )
                )
            }
        }
        .animation(.bouncy, value: vm.hasFilters)
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
                    color: showSearch ? appTint : .secondary
                )
            )
        }
        .transition(.move(edge: .top))
    }
    
    var MultiPicker: some View {
        Button {
            self.contentType = self.contentType == .games ? .news : .games
        } label: {
            Image(systemName: contentType.imageName)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
    
    var CategoryPicker: some View {
        Menu {
            ForEach(Category.allCases, id: \.id) { category in
                Button {
                    vm.categorySelected(for: category)
                    if hapticsEnabled {
                        HapticsManager.shared.vibrateForSelection()
                    }
                } label: {
                    Text(category.title)
                }
                .tag(category)
            }
        } label: {
            Text("Internet")
        }
    }
    
    var LibraryPicker: some View {
        Menu {
            Button {
                vm.librarySelectionTapped(allSelected: true, in: savedGames)
            } label: {
                Label("All saved games", systemImage: "bookmark.fill")
            }
            
            ForEach(savedLibraries, id: \.persistentModelID) { library in
                if savedLibraries.compactMap({$0.persistentModelID}).contains(library.persistentModelID) {
                    Button {
                        vm.librarySelectionTapped(allSelected: false, for: library, in: savedGames)
                    } label: {
                        Text(library.title)
                    }
                    .tag(library.persistentModelID)
                }
            }
        } label: {
            Text("Libraries")
        }
    }
}

