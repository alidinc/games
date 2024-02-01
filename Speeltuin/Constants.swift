//
//  Constants.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/11/2022.
//

import SwiftUI

struct Constants {
    
    static var AppStoreURL = "https://apps.apple.com/us/app/goodgames/id1662221677"
    static var GameSpotAPIKey = "ecd63198f3fba5326bad7e9f675821b17aaa0103"
    static var ButtonSize: CGFloat = 24
    static let allGamesLibraryID = "FC6AAA3D-5EEC-4852-847B-39982C11CD14"
    
    struct Alert {
        static let deleteLibraryAlertTitle = "Are you sure you want to delete this library?"
        static let deleteAllLibrariesAlertTitle = "Are you sure you want to delete all of your libraries?"
        static let undoAlertTitle = "This action cannot be undone."
        static let delete = "Delete"
        static let cancel = "Cancel"
        static let alreadySaved = "This content is already saved."
        static let alreadySavedMessage = "Would you like to delete it instead?"
    }
    
    struct UnavailableView {
        static let networkTitle = "No network available"
        static let networkMessage =  "We are unable to display any content as your iPhone is not currently connected to the internet."
        static let contentTitle = "No content available"
        static let contentNewsMessage = "We are unable to display any content, please save some news."
        static let contentGamesMessage = "We are unable to display any content, please enhance your query."
        static let contentFiltersTitle = "No content found for these filters"
        static let contentLibraryTitle = "No content found for this library"
        static let contentLibraryMessage = "We are unable to display any content, please save some games."
    }
    
    struct Size {
        static let maxWidthForDetails: CGFloat = 150
    }
    
    struct URLs {
        static var IGDB: URL {
            return URL(string: "https://www.igdb.com/")!
        }
        
        static var PureXbox: URL {
            return URL(string: "https://www.purexbox.com/")!
        }
        
        static var NintendoLife: URL {
            return URL(string: "https://www.nintendolife.com/")!
        }
        
        static var IGN: URL {
            return URL(string: "https://www.ign.com/uk")!
        }
        
        static func LinkedIn(profile: String) -> String {
            let webURLString = "https://www.linkedin.com/in/\(profile)"
            let appURLString = "linkedin://profile/\(profile)"
            
            if let appURL = URL(string: appURLString), UIApplication.shared.canOpenURL(appURL) {
                return appURLString
            } else if let webURL = URL(string: webURLString), UIApplication.shared.canOpenURL(webURL) {
                return webURLString
            } else {
                return webURLString
            }
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
        static let SearchURL = "https://api.igdb.com/v4/search"
        static let MultiQueryURL = "https://api.igdb.com/v4/multiquery"
        static let PlatformWebsitesURL = "https://api.igdb.com/v4/websites"
        static let OnboardingURL = "https://alidinc.github.io/onboarding/data/onboarding.json"
        static let CompaniesURL = "https://api.igdb.com/v4/companies"
        static let RequestType = "POST"
        static let ClientID = "9ipkbw3f1dzvsiz4mbigsvdy481y3s"
        static let ClientScreet = "xam1av902mpgwqasz4ujaamqn90rnq"
        
        static let SearchFields =
"""
alternative_name,character,checksum,collection,company,description,game,name,platform,published_at,test_dummy,theme;
"""
        static let CompanyField =
"""
change_date,change_date_category,changed_company_id,checksum,country,created_at,description,developed,logo,name,parent,published,slug,start_date,start_date_category,updated_at,url,websites;
"""
        
        static let DatabaseFields = 
"""
query platforms/count "Count of Platforms" {
       
      };
"""
        
        static let StandardFields =
"""
genres.name,name,platforms.*,total_rating,cover.url,first_release_date,release_dates.*,artworks.*,videos.video_id,websites.*,screenshots.url,summary
"""
        
        static let AllFields = "*"
        
        static let DetailFields =
"""
artworks.*,game_modes.name,genres.name,name,platforms.*,screenshots.url,summary,total_rating,rating_count,cover.url,first_release_date,release_dates.*,videos.video_id,websites.*,similar_games
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
