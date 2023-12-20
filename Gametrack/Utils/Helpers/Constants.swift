//
//  Constants.swift
//  UINews
//
//  Created by Ali Dinç on 22/11/2022.
//

import SwiftUI

struct Constants {
    
    static var AppStoreURL = "https://apps.apple.com/us/app/goodgames/id1662221677"
    static var GameSpotAPIKey = "ecd63198f3fba5326bad7e9f675821b17aaa0103"
    static var ButtonSize: CGFloat = 24
    
    struct URLs {
        static var IGDB: URL {
            return URL(string: "https://www.igdb.com/")!
        }
    }
    
    static let radius: CGFloat = 16
       static let indicatorHeight: CGFloat = 6
       static let indicatorWidth: CGFloat = 60
       static let snapRatio: CGFloat = 0.25
       static let minHeightRatio: CGFloat = 0.3
    
    struct Text {
        static let AddGames = "In order to see our recommendations here, please add some games to your collection."
        static let AddGamesForStats = "In order to see your stats here, please add some games to your collection."
        static let FindingSimilarGames = "Please wait, we're finding you similar games in your collection"
        static let UpdatedCollection = "There's been an update on your collection. Please wait, we're finding you some new recommendations"
        static let CuratedOnes = "Check out these curated ones just selected for you"
        static let EmptyCollectionsPlaceholder = "Why not enhance your collection of games by adding some more?"
        static let GamesTextField = "Search in database..."
        static let NotesTextField = "Please add your notes here..."
        static let TitleStats = "Stats"
        static let SubtitleStats = "Current statistics based on your collections"
    }
    
    struct IGDBAPI  {
        static let BaseURL = "https://api.igdb.com/v4/games"
        static let PlatformsURL = "https://api.igdb.com/v4/platforms"
        static let GenresURL = "https://api.igdb.com/v4/genres"
        static let MultiQueryURL = "https://api.igdb.com/v4/multiquery"
        static let PlatformWebsitesURL = "https://api.igdb.com/v4/websites"
        static let OnboardingURL = "https://alidinc.github.io/onboarding/data/onboarding.json"
        
        static let RequestType = "POST"
        static let ClientID = "9ipkbw3f1dzvsiz4mbigsvdy481y3s"
        static let ClientScreet = "xam1av902mpgwqasz4ujaamqn90rnq"
        
        static let DatabaseFields = """
query platforms/count "Count of Platforms" {
       
      };
"""
        static let StandardFields =
"""
genres.name,name,platforms.*,total_rating,cover.url,first_release_date,release_dates.*,artworks.*,videos.video_id,websites.*,screenshots.url,summary
"""
        
        static let DetailFields =
"""
artworks.*,game_modes.name,genres.name,name,platforms.*,screenshots.url,summary,total_rating,cover.url,first_release_date,release_dates.*,videos.video_id,websites.*,url,similar_games.artworks.*,similar_games.game_modes.name,similar_games.genres.name,similar_games.name,similar_games.platforms.*,similar_games.screenshots.url,similar_games.summary,similar_games.total_rating,similar_games.cover.url,similar_games.first_release_date,similar_games.release_dates.*,similar_games.videos.video_id,similar_games.websites.*,similar_games.url
"""
        static let PlatformFields =
"""
abbreviation,alternative_name,category,checksum,created_at,generation,name,platform_family,platform_logo,slug,summary,updated_at,url,versions,websites
"""
        
        static let PlatformWebsiteFields =
"""
category,checksum,trusted,url
"""
    }
}
