//
//  HomeViewModel.swift
//  A-games
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI
import Observation

@Observable
class DiscoverViewModel {
    
    var searchQuery = ""
    var fetchTaskToken: FetchTaskToken
    

    var dataFetchPhase = DataFetchPhase<[Game]>.empty
    
    private var cache: DiskCache<[Game]>?
    private var limit = 21
    private var offset = 0
    
    var games: [Game] {
        dataFetchPhase.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = dataFetchPhase {
            return true
        }
        return false
    }
    
    init() {
        self.cache = DiskCache<[Game]>(filename: "GamesCache",
                                       expirationInterval: 24 * 60 * 60 * 60)
        
        self.fetchTaskToken = FetchTaskToken(
            category: .topRated,
            platforms: [.database],
            genres: [.allGenres],
            token: .now
        )
    }
}

extension DiscoverViewModel {
    
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
