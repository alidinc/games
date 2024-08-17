//
//  GamesTabViews.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI

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
    
    var LibraryButton: some View {
        NavigationLink {
            LibrariesView()
        } label: {
            SFImage(
                config: .init(
                    name: "tray.full.fill",
                    padding: 10,
                    color: .primary
                )
            )
        }
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
                    color: .primary
                )
            )
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
}

