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

    var networkGames: [Game] {
        dataFetchPhase.value ?? []
    }
    
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
    
    func fetchGames() async {
        if Task.isCancelled { return }
        let category = self.fetchTaskToken.category
        let platforms = self.fetchTaskToken.platforms
        let genres = self.fetchTaskToken.genres
        
        if let cache, let games = await cache.value(forKey: category.rawValue) {
            DispatchQueue.main.async {
                self.dataFetchPhase = .success(games)
            }
            if Task.isCancelled { return }
            return
        }
        
        self.offset = 0
        DispatchQueue.main.async {
            self.dataFetchPhase = .empty
        }
        
        do {
            let response = try await NetworkManager.shared.fetchDetailedGames(query: searchQuery.lowercased(),
                                                                              with: category,
                                                                              platforms: platforms,
                                                                              genres: genres,
                                                                              limit: self.limit,
                                                                              offset: self.offset)
            if Task.isCancelled { return }
            DispatchQueue.main.async {
                self.dataFetchPhase = .success(response)
            }
            if !response.isEmpty, let cache {
                await cache.setValue(response, forKey: category.rawValue)
            }
        } catch {
            if Task.isCancelled { return }
            DispatchQueue.main.async {
                self.dataFetchPhase = .failure(error)
            }
        }
    }
    
    @MainActor
    func fetchNextSetOfGames() async {
        if Task.isCancelled { return }
        let category = self.fetchTaskToken.category
        let platforms = self.fetchTaskToken.platforms
        let genres = self.fetchTaskToken.genres
        let games = self.dataFetchPhase.value ?? []
        
        
        DispatchQueue.main.async {
            self.dataFetchPhase = .fetchingNextPage(games)
        }
        
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
            
            DispatchQueue.main.async {
                self.dataFetchPhase = .success(totalGames)
            }
            
            if !totalGames.isEmpty, let cache  {
                await cache.setValue(totalGames, forKey: category.rawValue)
            }
        } catch {
            if Task.isCancelled { return }
            DispatchQueue.main.async {
                self.dataFetchPhase = .failure(error)
            }
        }
    }
    
    func hasReachedEnd(of game: Game) -> Bool {
        guard let lastGame = networkGames.last  else {
            return false
        }
        
        return (lastGame.id == game.id) && ((networkGames.count - 1) == networkGames.lastIndex(of: game))
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
        
        Task {
            await refreshTask()
        }
    }
    
    func librarySelectionTapped(allSelected: Bool, for library: Library? = nil, in savedGames: [SavedGame]) {
        headerTitle = "All games"
        headerImageName =  "bookmark"
        searchPlaceholder = "Search in library"
        dataType = .library
        filterType = .library
        
        if allSelected {
            filterSegment(games: savedGames)
        } else {
            if let library {
                headerTitle = library.title
                if let icon = library.icon {
                    headerImageName = icon
                }
            }
            
            filterSegment(games: savedGames, library: library)
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
        case .library:
            fetchTaskToken.genres = newValue
            filterSegment(games: savedGames, library: library)
        }
        
        Task {
            await refreshTask()
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
        case .library:
            fetchTaskToken.platforms = newValue
            filterSegment(games: savedGames, library: library)
        }
        
        Task {
            await refreshTask()
        }
    }
    
    func toggleGenre(_ genre: PopularGenre, selectedLibrary: Library?,  games: [SavedGame]) {
        switch dataType {
        default:
            if fetchTaskToken.genres.contains(genre) {
                if let index = fetchTaskToken.genres.firstIndex(of: genre) {
                    fetchTaskToken.genres.remove(at: index)
                    filterSegment(games: games)
                }
            } else {
                fetchTaskToken.genres.removeAll(where: { $0.id == PopularGenre.allGenres.id })
                fetchTaskToken.genres.append(genre)
                filterSegment(games: games, library: selectedLibrary)
            }
        }
    }
    
    func togglePlatform(_ platform: PopularPlatform, selectedLibrary: Library?, games: [SavedGame]) {
        switch dataType {
        default:
            if fetchTaskToken.platforms.contains(platform) {
                if let index = fetchTaskToken.platforms.firstIndex(of: platform) {
                    fetchTaskToken.platforms.remove(at: index)
                    filterSegment(games: games)
                }
                
            } else {
                fetchTaskToken.platforms.removeAll(where: { $0.id == PopularPlatform.database.id })
                fetchTaskToken.platforms.append(platform)
                filterSegment(games: games, library: selectedLibrary)
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
    
    func filterSegment(games: [SavedGame], library: Library? = nil)  {
        var libraryGames = [SavedGame]()
        let selectedGenres = fetchTaskToken.genres.filter({$0 != PopularGenre.allGenres })
        let selectedPlatforms = fetchTaskToken.platforms.filter({ $0 != PopularPlatform.database })
        
        if let library {
            libraryGames = games.filter({ $0.library == library })
        } else {
            libraryGames = games
        }
        
        if self.searchQuery.isEmpty {
            self.savedGames = libraryGames
                .filter({$0.containsPopularGenres(selectedGenres)})
                .filter({$0.containsPopularPlatforms(selectedPlatforms)})
        } else {
            self.savedGames = libraryGames
                .filter({($0.game?.name ?? "").lowercased().contains(self.searchQuery.lowercased())})
                .filter({$0.containsPopularGenres(selectedGenres)})
                .filter({$0.containsPopularPlatforms(selectedPlatforms)})
        }
    }
}
