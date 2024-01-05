//
//  LibraryViewModel.swift
//  Gametrack
//
//  Created by Ali Dinç on 04/01/2024.
//

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
        
        let libraryGames = games.filter({ $0.libraryType.id == selectedLibraryType.id })
        
        if selectedLibraryType == .all {
            if searchQuery.isEmpty {
                savedGames = games
                    .filter({$0.containsPopularGenres(selectedGenres)})
                    .filter({$0.containsPopularPlatforms(selectedPlatforms)})
            } else {
                if !selectedGenres.isEmpty {
                    savedGames = games
                        .filter({($0.game?.name ?? "").lowercased().contains(searchQuery.lowercased())})
                        .filter({$0.containsPopularGenres(selectedGenres)})
                } else if !selectedPlatforms.isEmpty {
                    savedGames = games
                        .filter({($0.game?.name ?? "").lowercased().contains(searchQuery.lowercased())})
                        .filter({$0.containsPopularPlatforms(selectedPlatforms)})
                } else {
                    savedGames = games
                        .filter({($0.game?.name ?? "").lowercased().contains(searchQuery.lowercased())})
                }
            }
        } else {
            if searchQuery.isEmpty {
                savedGames = libraryGames
                    .filter({$0.containsPopularGenres(selectedGenres)})
                    .filter({$0.containsPopularPlatforms(selectedPlatforms)})
            } else {
                if !selectedGenres.isEmpty {
                    savedGames = libraryGames
                        .filter({($0.game?.name ?? "").lowercased().contains(searchQuery.lowercased())})
                        .filter({$0.containsPopularGenres(selectedGenres)})
                } else if !selectedPlatforms.isEmpty {
                    savedGames = libraryGames
                        .filter({($0.game?.name ?? "").lowercased().contains(searchQuery.lowercased())})
                        .filter({$0.containsPopularPlatforms(selectedPlatforms)})
                } else {
                    savedGames = libraryGames
                        .filter({($0.game?.name ?? "").lowercased().contains(searchQuery.lowercased())})
                }
            }
        }
    }
}
