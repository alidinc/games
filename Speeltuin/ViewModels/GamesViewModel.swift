//
//  HomeViewModel.swift
//  Speeltuin
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI
import Observation

@Observable
class GamesViewModel {
    
    var showDetails = false
    var limit = 21
    var offset = 0
    var fetchTaskToken: FetchTaskToken
    var dataFetchPhase = DataFetchPhase<[Game]>.empty
    var headerTitle = ""
    var headerImageName = ""
    var searchQuery = ""
    var searchPlaceholder = "Search in network"
    var savedGamesListId = ""
    var dataType: DataType = .network
    var filterType: FilterType = .search
    var savedGames: [SPGame] = []
    var selectedLibrary: SPLibrary?
    var cache = DiskCache<[Game]>(filename: "GamesCache",
                                  expirationInterval: 24 * 60 * 60 * 60)
    
    init() {
        self.fetchTaskToken = FetchTaskToken(
            category: .database,
            platforms: [.database],
            genres: [.allGenres],
            token: .now
        )
        
        headerTitle = fetchTaskToken.category.title
        headerImageName = fetchTaskToken.category.systemImage
        
        Task {
            await self.fetchGames()
        }
    }
}

// MARK: - Networking
extension GamesViewModel {
    
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
    
    @MainActor
    func refreshTask() async {
        self.offset = 0
        self.dataFetchPhase = .empty
        self.fetchTaskToken.token = Date()
        await self.cache.removeValue(forKey: self.fetchTaskToken.category.rawValue)
    }
    
    @MainActor
    func fetchGames() async {
        if Task.isCancelled { return }
        let category = self.fetchTaskToken.category
        let platforms = self.fetchTaskToken.platforms
        let genres = self.fetchTaskToken.genres
        
        if  let games = await cache.value(forKey: category.rawValue) {
            self.dataFetchPhase = .success(games)
            if Task.isCancelled { return }
            return
        }
        
        self.offset = 0
        self.dataFetchPhase = .loading
        
        do {
            let response = try await NetworkManager.shared
                .fetchDetailedGames(
                    query: searchQuery.lowercased(),
                    with: category,
                    platforms: platforms,
                    genres: genres,
                    limit: self.limit,
                    offset: self.offset
                )
            if Task.isCancelled { return }
            
            if !response.isEmpty {
                self.dataFetchPhase = .success(response)
                await self.cache.setValue(response, forKey: category.rawValue)
            } else {
                self.dataFetchPhase = .empty
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
        
        do {
            try await Task.sleep(seconds: 0.05)
            self.dataFetchPhase = .fetchingNextPage(games)
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            self.offset += self.limit
            let response = try await NetworkManager.shared
                .fetchDetailedGames(
                    query: searchQuery.lowercased(),
                    with: category,
                    platforms: platforms,
                    genres: genres,
                    limit: self.limit,
                    offset: self.offset
                )
            
            let totalGames = games + response
            if Task.isCancelled { return }
            
            if !totalGames.isEmpty {
                self.dataFetchPhase = .success(totalGames)
                await self.cache.setValue(totalGames, forKey: category.rawValue)
            } else {
                self.dataFetchPhase = .empty
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

// MARK: - Filtering
extension GamesViewModel {
    
    func refreshList() {
        self.savedGamesListId = UUID().uuidString
    }
    
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
    
    func librarySelectionTapped(allSelected: Bool, for library: SPLibrary? = nil, in savedGames: [SPGame]) {
        searchPlaceholder = "Search in library"
        dataType = .library
        filterType = .library
        
        if allSelected {
            headerTitle = "All games"
            headerImageName =  "bookmark.fill"
        } else {
            if let library {
                headerTitle = library.title
                headerImageName = library.icon
            }
        }
        
        refreshList()
        filterSegment(savedGames: savedGames)
    }
    
    func onChangeOfDataType(savedGames: [SPGame], library: SPLibrary?, newValue: DataType) {
        switch newValue {
        case .network:
            Task {
                await refreshTask()
            }
        case .library:
            filterSegment(savedGames: savedGames)
        }
    }
    
    func onChangeQuery(
        for games: [SPGame],
        newValue: String
    ) {
        filterType = .search
        
        switch dataType {
        case .network:
            Task {
                if !newValue.isEmpty {
                    try await Task.sleep(seconds: 0.5)
                    await refreshTask()
                } else {
                    await refreshTask()
                }
            }
        case .library:
            filterSegment(savedGames: games)
        }
    }
    
    func onChangeGenres(
        for savedGames: [SPGame],
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
            filterSegment(savedGames: savedGames)
        }
    }
    
    func onChangePlatforms(
        for savedGames: [SPGame],
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
            filterSegment(savedGames: savedGames)
        }
    }
    
    func toggleGenre(_ genre: PopularGenre, selectedLibrary: SPLibrary?,  savedGames: [SPGame]) {
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
    
    func togglePlatform(_ platform: PopularPlatform, selectedLibrary: SPLibrary?, savedGames: [SPGame]) {
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
    
    func filterSegment(savedGames: [SPGame]) {
        withAnimation {
            var libraryGames = selectedLibrary != nil ? savedGames.filter({ $0.library == selectedLibrary }) : savedGames
            let selectedGenres = fetchTaskToken.genres.filter({ $0 != PopularGenre.allGenres })
            let selectedPlatforms = fetchTaskToken.platforms.filter({ $0 != PopularPlatform.database })

            if self.searchQuery.isEmpty {
                self.savedGames = libraryGames.filter {
                    ($0.containsGenres(selectedGenres) || selectedGenres.isEmpty) &&
                    ($0.containsPlatforms(selectedPlatforms) || selectedPlatforms.isEmpty)
                }
            } else {
                self.savedGames = libraryGames.filter {
                    $0.game?.name?.lowercased().contains(self.searchQuery.lowercased()) ?? false &&
                    ($0.containsSelections(selectedGenres, selectedPlatforms) || (selectedGenres.isEmpty && selectedPlatforms.isEmpty))
                }
            }
        }
    }
}
