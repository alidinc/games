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
    var selectedPlatforms: Set<PopularPlatform> = []
    var selectedGenres: Set<PopularGenre> = []

    var searchQuery = "" {
        didSet {
            debounceSearchQuery()
        }
    }

    var searchPlaceholder = "Search in network"
    var savedGamesListId = ""
    var dataType: DataType = .network
    var filterType: FilterType = .search
    var savedGames: [SavedGame] = []
    var selectedLibrary: Library?
    var cache = DiskCache<[Game]>(filename: "GamesCache",
                                  expirationInterval: 24 * 60 * 60 * 60)

    // Debounce-related properties
    private var searchQueryDebounceTask: Task<Void, Never>? = nil

    init() {
        self.fetchTaskToken = FetchTaskToken(
            category: .database,
            platforms: [.database],
            genres: [.allGenres],
            token: .now
        )

        Task {
            await self.fetchGames()
        }
    }

    private func debounceSearchQuery() {
        // Cancel the previous debounce task if it exists
        searchQueryDebounceTask?.cancel()

        // Create a new debounce task
        searchQueryDebounceTask = Task {
            // Wait for the debounce interval
            try? await Task.sleep(seconds: 0.5)

            // Only perform the search if the query length is greater than 3
            if searchQuery.count > 3 {
                await refreshTask()
            }
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

    var hasLibraryFilters: Bool {
        !self.selectedGenres.isEmpty || !self.selectedPlatforms.isEmpty
    }

    func resetLibraryFilters() {
        self.selectedGenres = []
        self.selectedPlatforms = []
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
        if fetchTaskToken.genres.isEmpty || fetchTaskToken.platforms.isEmpty {
            fetchTaskToken.genres = [.allGenres]
            fetchTaskToken.platforms = [.database]
        }
        Task {
            await refreshTask()
        }
    }

    func toggleGenre(_ genre: PopularGenre) {
        fetchTaskToken.genres.removeAll()
        fetchTaskToken.genres.append(genre)
        Task {
            await refreshTask()
        }
    }

    func togglePlatform(_ platform: PopularPlatform) {
        fetchTaskToken.platforms.removeAll()
        fetchTaskToken.platforms.append(platform)
        Task {
            await refreshTask()
        }
    }

    func removeFilters() {
        fetchTaskToken.platforms = [.database]
        fetchTaskToken.genres = [.allGenres]
    }
}
