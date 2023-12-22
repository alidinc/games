//
//  SocialsView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct SocialsView: View {
    
    var game: Game
    
    var body: some View {
        if let websites = game.websites, !websites.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 20) {
                    ForEach(websites, id: \.id) { website in
                        if let url = website.url,
                           let websiteURL = URL(string: url),
                           let platform = website.platformWebsite {
                            Link(destination: websiteURL) {
                                if platform == .official {
                                    Image(systemName: platform.imageName)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.white)
                                } else {
                                    Image(platform.imageName)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                        }
                    }
                }
                .padding(10)
            }
            .padding(10)
            .cornerRadius(10)
        }
    }
}

enum PlatformWebsite: Int, CaseIterable {
    case youtube = 9
    case twitch = 6
    case wiki = 3
    case iphone = 10
    case ipad = 11
    case android = 12
    case reddit = 14
    case discord = 18
    case official = 1
    case steam = 13
    case facebook = 4
    case instagram = 8
    case twitter = 5
    
    var imageName: String {
        switch self {
        case .youtube:
            return "youtube"
        case .twitch:
            return "twitch"
        case .wiki:
            return "wikipedia"
        case .iphone:
            return "ios"
        case .ipad:
            return "ios"
        case .android:
            return "android"
        case .reddit:
            return "reddit"
        case .discord:
            return "discord"
        case .official:
            return "network"
        case .steam:
            return "steam"
        case .facebook:
            return "facebook"
        case .instagram:
            return "instagram"
        case .twitter:
            return "twitter"
        }
    }
}
