//
//  LibraryViewModel.swift
//  Gametrack
//
//  Created by Ali Dinç on 04/01/2024.
//

import Foundation
import SwiftData
import Observation


enum FilterType {
    case search
    case platform
    case genre
    case library
}


@Observable
class LibraryViewModel {
    
    var savedGames: [SavedGame] = []
    
    var selectedPlatforms: [PopularPlatform] = []
    var selectedGenres: [PopularGenre] = []
    var selectedLibraryType: LibraryType = .all
   
    var searchQuery = ""
   

    func filterSegment(games: [SavedGame])  {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            let libraryGames = games.filter({ $0.libraryType.id == self.selectedLibraryType.id })
            
            if self.selectedLibraryType == .all {
                if self.searchQuery.isEmpty {
                    self.savedGames = games
                        .filter({$0.containsPopularGenres(self.selectedGenres)})
                        .filter({$0.containsPopularPlatforms(self.selectedPlatforms)})
                } else {
                    if !self.selectedGenres.isEmpty {
                        self.savedGames = games
                            .filter({($0.game?.name ?? "").lowercased().contains(self.searchQuery.lowercased())})
                            .filter({$0.containsPopularGenres(self.selectedGenres)})
                    } else if !selectedPlatforms.isEmpty {
                        self.savedGames = games
                            .filter({($0.game?.name ?? "").lowercased().contains(self.searchQuery.lowercased())})
                            .filter({$0.containsPopularPlatforms(self.selectedPlatforms)})
                    } else {
                        self.savedGames = games
                            .filter({($0.game?.name ?? "").lowercased().contains(self.searchQuery.lowercased())})
                    }
                }
            } else {
                if self.searchQuery.isEmpty {
                    self.savedGames = libraryGames
                        .filter({$0.containsPopularGenres(self.selectedGenres)})
                        .filter({$0.containsPopularPlatforms(self.selectedPlatforms)})
                } else {
                    if !self.selectedGenres.isEmpty {
                        self.savedGames = libraryGames
                            .filter({($0.game?.name ?? "").lowercased().contains(self.searchQuery.lowercased())})
                            .filter({$0.containsPopularGenres(self.selectedGenres)})
                    } else if !self.selectedPlatforms.isEmpty {
                        self.savedGames = libraryGames
                            .filter({($0.game?.name ?? "").lowercased().contains(self.searchQuery.lowercased())})
                            .filter({$0.containsPopularPlatforms(self.selectedPlatforms)})
                    } else {
                        self.savedGames = libraryGames
                            .filter({($0.game?.name ?? "").lowercased().contains(self.searchQuery.lowercased())})
                    }
                }
            }
        }
    }
}
