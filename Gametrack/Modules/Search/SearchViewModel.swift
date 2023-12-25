//
//  SearchViewModel.swift
//  Gametrack
//
//  Created by Ali Dinç on 24/12/2023.
//

import Combine
import SwiftUI
import Observation

@Observable
class SearchViewModel {
    
    var searchFTT: FetchTaskToken
    var searchDFP: DataFetchPhase<[Game]> = .empty
    var searchQuery = ""
    
    private var limit = 21
    private var offset = 0
    
    var games: [Game] {
        searchDFP.value ?? []
    }
    
    init(selectedCategory: Category = .database,
         selectedPlatform: PopularPlatform = .database,
         selectedGenre: PopularGenre = .allGenres) {
        
        self.searchFTT = FetchTaskToken(category: selectedCategory,
                                        platforms: [selectedPlatform],
                                        genres: [selectedGenre],
                                        token: .now)
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = searchDFP {
            return true
        }
        return false
    }
    
    // MARK: - Public
    
    @Sendable
    func refreshTask() async {
        self.offset = 0
        self.searchDFP = .empty
        self.searchFTT.token = Date()
    }
    
    func search() async {
        Task {
            await self.refreshTask()
            await self.fetchGames()
        }
    }
    
    func fetchGames() async {
        if Task.isCancelled { return }
        self.offset = 0
        let searchQuery = self.searchQuery.lowercased()
        
        
        guard !searchQuery.isEmpty else {
            self.searchDFP = .empty
            return
        }
        
        do {
            let games = try await NetworkManager.shared.fetchDetailedGames(
                query: searchQuery,
                with: searchFTT.category,
                platforms: searchFTT.platforms,
                genres: searchFTT.genres,
                limit: self.limit,
                offset: self.offset
            )
            if Task.isCancelled { return }
            if searchQuery != searchQuery {
                return
            }
            
            self.searchDFP = .success(games)
            
        } catch {
            if Task.isCancelled { return }
            if searchQuery != searchQuery {
                return
            }
            self.searchDFP = .failure(error)
        }
    }
    
    func fetchNextSetOfGames() async {
        if Task.isCancelled { return }
        let games = self.searchDFP.value ?? []
        self.searchDFP = .fetchingNextPage(games)
        
        do {
            self.offset += self.limit
            let response = try await NetworkManager.shared.fetchDetailedGames(
                query: searchQuery,
                with: searchFTT.category,
                platforms: searchFTT.platforms,
                genres: searchFTT.genres,
                limit: self.limit,
                offset: self.offset
            )
            
            if Task.isCancelled { return }
            self.searchDFP = .success(games + response)
            
        } catch {
            if Task.isCancelled { return }
            self.searchDFP = .failure(error)
        }
    }
    
    func hasReachedEnd(of game: Game) -> Bool {
        let games = self.searchDFP.value ?? []
        return games.last?.id == game.id
    }
}
