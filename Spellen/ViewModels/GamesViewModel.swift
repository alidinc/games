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
    var searchPlaceholder = ""
    var savedGames: [SavedGame] = []
    
    var games: [Game] {
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
        guard let lastGame = games.last  else {
            return false
        }
        
        return (lastGame.id == game.id) && ((games.count - 1) == games.lastIndex(of: game))
    }
}

extension GamesViewModel {
    
    func toggleGenre(_ genre: PopularGenre) {
        if fetchTaskToken.genres.contains(genre) {
            if let index = fetchTaskToken.genres.firstIndex(of: genre) {
                fetchTaskToken.genres.remove(at: index)
            }
        } else {
            fetchTaskToken.genres.removeAll(where: { $0.id == PopularGenre.allGenres.id })
            fetchTaskToken.genres.append(genre)
        }
    }
    
    func togglePlatform(_ platform: PopularPlatform) {
        if fetchTaskToken.platforms.contains(platform) {
            if let index = fetchTaskToken.platforms.firstIndex(of: platform) {
                fetchTaskToken.platforms.remove(at: index)
            }
            
        } else {
            fetchTaskToken.platforms.removeAll(where: { $0.id == PopularPlatform.database.id })
            fetchTaskToken.platforms.append(platform)
        }
    }
    
    func removeFilters(games: [SavedGame], library: Library? = nil, libraries: [Library]) {
        fetchTaskToken.platforms = []
        fetchTaskToken.genres = []
        
        Task {
            await refreshTask()
        }
        
        filterSegment(games: games, library: library, libraries: libraries)
    }
    
    func filterSegment(games: [SavedGame], library: Library? = nil, libraries: [Library])  {
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
