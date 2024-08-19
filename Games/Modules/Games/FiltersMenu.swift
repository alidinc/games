//
//  FiltersMenu.swift
//  Games
//
//  Created by Ali Dinç on 19/08/2024.
//

import SwiftUI

struct FiltersMenu: View {

    let contentType: ContentType

    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("appTint") private var appTint: Color = .blue

    @Bindable var gamesVM: GamesViewModel
    @Bindable var newsVM: NewsViewModel

    var body: some View {
        Menu {
            switch contentType {
            case .games:
                Menu {
                    ForEach(Category.allCases) { category in
                        Button(category.title, systemImage: category.systemImage) {
                            gamesVM.categorySelected(for: category)
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
                            gamesVM.togglePlatform(platform)
                        } label: {
                            HStack {
                                Text(platform.title)
                                if gamesVM.fetchTaskToken.platforms.contains(platform) {
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

                            gamesVM.toggleGenre(genre)
                        } label: {
                            HStack {
                                Text(genre.title)
                                if gamesVM.fetchTaskToken.genres.contains(genre) {
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
                    gamesVM.fetchTaskToken.platforms = [.database]
                    gamesVM.fetchTaskToken.genres = [.allGenres]
                    Task {
                        await gamesVM.refreshTask()
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

                            if !self.gamesVM.selectedGenres.contains(genre) {
                                self.gamesVM.selectedGenres.insert(genre)
                            } else {
                                self.gamesVM.selectedGenres.remove(genre)
                            }
                        } label: {
                            HStack {
                                Text(genre.title)
                                if self.gamesVM.selectedGenres.contains(genre) {
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

                            if !self.gamesVM.selectedPlatforms.contains(platform) {
                                self.gamesVM.selectedPlatforms.insert(platform)
                            } else {
                                self.gamesVM.selectedPlatforms.remove(platform)
                            }
                        } label: {
                            HStack {
                                Text(platform.title)
                                if gamesVM.fetchTaskToken.platforms.contains(platform) {
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
                    self.resetLibraryFilters()
                } label: {
                    Text("Remove filters")
                }
            }
        } label: {
            SFImage(
                config: .init(
                    name: "slider.horizontal.3",
                    padding: 10,
                    color: gamesVM.hasLibraryFilters ? appTint : .primary
                )
            )
        }
        .animation(.bouncy, value: gamesVM.hasFilters)
    }

    func resetLibraryFilters() {
        self.gamesVM.selectedGenres = []
        self.gamesVM.selectedPlatforms = []
    }
}
