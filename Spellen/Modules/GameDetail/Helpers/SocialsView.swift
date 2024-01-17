//
//  SocialsView.swift
//  JustGames
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct SocialsView: View {
    
    var game: Game
    
    var body: some View {
        if let websites = game.websites, !websites.isEmpty {
            VStack(alignment: .leading) {
                Text("Links")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        ForEach(websites, id: \.id) { website in
                            if let url = website.url,
                               let websiteURL = URL(string: url),
                               let category = website.category,
                               let platform = PlatformWebsite(rawValue: category) {
                                Link(destination: websiteURL) {
                                    if platform == .official {
                                        Image(systemName: platform.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .padding()
                                            .foregroundStyle(.white)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                    } else {
                                        Image(platform.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .padding()
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

enum PlatformWebsite: Int, CaseIterable, Codable {
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
    case x = 5
    
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
        case .x:
            return "x"
        }
    }
}
