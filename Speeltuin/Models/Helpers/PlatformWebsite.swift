//
//  PlatformWebsite.swift
//  Speeltuin
//
//  Created by alidinc on 31/01/2024.
//

import Foundation

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
    
    var title: String {
        switch self {
        case .youtube:
            return "Youtube"
        case .twitch:
            return "Twitch"
        case .wiki:
            return "Wikipedia"
        case .iphone:
            return "iOS"
        case .ipad:
            return "iPadOS"
        case .android:
            return "Android"
        case .reddit:
            return "Reddit"
        case .discord:
            return "Discord"
        case .official:
            return "Official"
        case .steam:
            return "Steam"
        case .facebook:
            return "Facebook"
        case .instagram:
            return "Instagram"
        case .x:
            return "X"
        }
    }
}
