//
//  HomeViewModel.swift
//  JustGames
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI
import Observation

@Observable
class GamesViewModel {
    
    var fetchTaskToken: FetchTaskToken
    var dataFetchPhase = DataFetchPhase<[Game]>.empty
    
    var headerTitle = ""
    var headerImageName = ""
    var searchQuery = ""
    var searchPlaceholder = "Search in network"
    var dataType: DataType = .network
    var filterType: FilterType = .search
    
    var savedGames: [SavedGame] = []
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = dataFetchPhase {
            return true
        }
        return false
    }
    
    var hasFilters: Bool {
        (!fetchTaskToken.genres.isEmpty && !fetchTaskToken.genres.contains(.allGenres))
        || (!fetchTaskToken.platforms.isEmpty && !fetchTaskToken.platforms.contains(.database))
    }
    
    private var cache: DiskCache<[Game]>?
    private var limit = 21
    private var offset = 0
    
    init() {
        self.cache = DiskCache<[Game]>(filename: "GamesCache",
                                       expirationInterval: 24 * 60 * 60 * 60)
        
        self.fetchTaskToken = FetchTaskToken(
            category: .topRated,
            platforms: [.database],
            genres: [.allGenres],
            token: .now
        )
        
        headerTitle = fetchTaskToken.category.title
        headerImageName = fetchTaskToken.category.systemImage
    }
}

extension GamesViewModel {
    
    @MainActor
    func refreshTask() async {
        self.offset = 0
        self.dataFetchPhase = .empty
        self.fetchTaskToken.token = Date()
        if let cache = self.cache {
            await cache.removeValue(forKey: self.fetchTaskToken.category.rawValue)
        }
    }
    
    @MainActor
    func fetchGames() async {
        if Task.isCancelled { return }
        let category = self.fetchTaskToken.category
        let platforms = self.fetchTaskToken.platforms
        let genres = self.fetchTaskToken.genres
        
        if let cache, let games = await cache.value(forKey: category.rawValue) {
            self.dataFetchPhase = .success(games)
            if Task.isCancelled { return }
            return
        }
        
        self.offset = 0
        self.dataFetchPhase = .empty
        
        do {
            let response = try await NetworkManager.shared.fetchDetailedGames(query: searchQuery.lowercased(),
                                                                              with: category,
                                                                              platforms: platforms,
                                                                              genres: genres,
                                                                              limit: self.limit,
                                                                              offset: self.offset)
            if Task.isCancelled { return }
            self.dataFetchPhase = .success(response)
            if !response.isEmpty, let cache {
                await cache.setValue(response, forKey: category.rawValue)
            }
        } catch {
            if Task.isCancelled { return }
            self.dataFetchPhase = .failure(error)
        }
    }
    
    @MainActor
    func fetchNextSetOfGames() async {
        if Task.isCancelled { return }
        let category = self.fetchTaskToken.category
        let platforms = self.fetchTaskToken.platforms
        let genres = self.fetchTaskToken.genres
        let games = self.dataFetchPhase.value ?? []
        
        
        self.dataFetchPhase = .fetchingNextPage(games)
        
        do {
            self.offset += self.limit
            let response = try await NetworkManager.shared.fetchDetailedGames(query: searchQuery.lowercased(),
                                                                              with: category,
                                                                              platforms: platforms,
                                                                              genres: genres,
                                                                              limit: self.limit,
                                                                              offset: self.offset)
            
            let totalGames = games + response
            if Task.isCancelled { return }
            
            self.dataFetchPhase = .success(totalGames)
            
            if !totalGames.isEmpty, let cache  {
                await cache.setValue(totalGames, forKey: category.rawValue)
            }
        } catch {
            if Task.isCancelled { return }
            self.dataFetchPhase = .failure(error)
        }
    }
    
    func hasReachedEnd(of game: Game) -> Bool {
        guard let games = dataFetchPhase.value, let lastGame = games.last  else {
            return false
        }
        
        return (lastGame.id == game.id) && ((games.count - 1) == games.lastIndex(of: game))
    }
}

extension GamesViewModel {
    
    func categorySelected(for category: Category) {
        fetchTaskToken.category = category
        headerTitle = category.title
        headerImageName = category.systemImage
        searchPlaceholder = "Search in network"
        dataType = .network
        filterType = .search
        
        if fetchTaskToken.genres.isEmpty || fetchTaskToken.platforms.isEmpty {
            fetchTaskToken.genres = [.allGenres]
            fetchTaskToken.platforms = [.database]
        }
        
        Task {
            await refreshTask()
        }
    }
    
    func librarySelectionTapped(allSelected: Bool, for library: Library? = nil, in savedGames: [SavedGame]) {
        searchPlaceholder = "Search in library"
        dataType = .library
        filterType = .library
        
        if allSelected {
            headerTitle = "All games"
            headerImageName =  "bookmark"
            filterSegment(savedGames: savedGames)
        } else {
            if let library {
                headerTitle = library.title
                headerImageName = library.icon
            }
            
            filterSegment(savedGames: savedGames, library: library)
        }
    }
    
    func onChangeOfDataType(savedGames: [SavedGame], library: Library?, newValue: DataType) {
        switch newValue {
        case .network:
            if fetchTaskToken.genres.isEmpty || fetchTaskToken.platforms.isEmpty {
                fetchTaskToken.genres = [.allGenres]
                fetchTaskToken.platforms = [.database]
            }
            
            Task {
                await refreshTask()
            }
        case .library:
            filterSegment(savedGames: savedGames, library: library)
        }
    }
    
    func onChangeGenres(
        for savedGames: [SavedGame],
        in library: Library?,
        newValue: [PopularGenre]
    ) {
        filterType = .genre
        switch dataType {
        case .network:
            if fetchTaskToken.genres.isEmpty {
                fetchTaskToken.genres = [.allGenres]
            } else {
                fetchTaskToken.genres = newValue
            }
            
            Task {
                await refreshTask()
            }
            
        case .library:
            fetchTaskToken.genres = newValue
            filterSegment(savedGames: savedGames, library: library)
        }
    }
    
    func onChangePlatforms(
        for savedGames: [SavedGame],
        in library: Library?,
        newValue: [PopularPlatform]
    ) {
        filterType = .platform
        switch dataType {
        case .network:
            if fetchTaskToken.platforms.isEmpty {
                fetchTaskToken.platforms = [.database]
            } else {
                fetchTaskToken.platforms = newValue
            }
            
            Task {
                await refreshTask()
            }
        case .library:
            fetchTaskToken.platforms = newValue
            filterSegment(savedGames: savedGames, library: library)
        }
    }
    
    func toggleGenre(_ genre: PopularGenre, selectedLibrary: Library?,  savedGames: [SavedGame]) {
        switch dataType {
        default:
            if fetchTaskToken.genres.contains(genre) {
                if let index = fetchTaskToken.genres.firstIndex(of: genre) {
                    fetchTaskToken.genres.remove(at: index)
                }
            } else {
                fetchTaskToken.genres.removeAll(where: { $0.id == PopularGenre.allGenres.id })
                fetchTaskToken.genres.append(genre)
            }
        }
    }
    
    func togglePlatform(_ platform: PopularPlatform, selectedLibrary: Library?, savedGames: [SavedGame]) {
        switch dataType {
        default:
            if fetchTaskToken.platforms.contains(platform) {
                if let index = fetchTaskToken.platforms.firstIndex(of: platform) {
                    fetchTaskToken.platforms.remove(at: index)
                }
                
            } else {
                fetchTaskToken.platforms.removeAll(where: { $0.id == PopularPlatform.database.id })
                fetchTaskToken.platforms.append(platform)
            }
        }
    }
    
    func removeFilters() {
        switch dataType {
        case .network:
            fetchTaskToken.platforms = [.database]
            fetchTaskToken.genres = [.allGenres]
        case .library:
            fetchTaskToken.platforms = []
            fetchTaskToken.genres = []
        }
    }
    
    func filterSegment(savedGames: [SavedGame], library: Library? = nil)  {
        var libraryGames = [SavedGame]()
        let selectedGenres = fetchTaskToken.genres.filter({$0 != PopularGenre.allGenres })
        let selectedPlatforms = fetchTaskToken.platforms.filter({ $0 != PopularPlatform.database })
        
        
        if let library {
            libraryGames = savedGames.filter({ $0.library == library })
        } else {
            libraryGames = savedGames
        }
        
        if self.searchQuery.isEmpty {
            if !selectedGenres.isEmpty {
                if !selectedPlatforms.isEmpty {
                    self.savedGames = libraryGames
                        .filter({ $0.containsGenres(selectedGenres) })
                        .filter({ $0.containsPlatforms(selectedPlatforms) })
                } else {
                    self.savedGames = libraryGames
                        .filter({ $0.containsGenres(selectedGenres) })
                }
            } else if !selectedPlatforms.isEmpty {
                if !selectedGenres.isEmpty {
                    self.savedGames = libraryGames
                        .filter({ $0.containsGenres(selectedGenres) })
                        .filter({ $0.containsPlatforms(selectedPlatforms) })
                } else {
                    self.savedGames = libraryGames
                        .filter({ $0.containsPlatforms(selectedPlatforms) })
                }
            } else {
                self.savedGames = libraryGames
            }
        } else {
            if !selectedGenres.isEmpty || !selectedPlatforms.isEmpty {
                self.savedGames = libraryGames
                    .filter({( $0.game?.name ?? "").lowercased().contains(self.searchQuery.lowercased()) })
                    .filter({ $0.containsSelections(selectedGenres, selectedPlatforms) })
            } else {
                self.savedGames = libraryGames
                    .filter({( $0.game?.name ?? "").lowercased().contains(self.searchQuery.lowercased()) })
            }
        }
    }
}
