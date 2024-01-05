//
//  Platform.swift
//  Monark
//
//  Created by Ali Dinç on 06/12/2022.
//


enum PopularPlatform: Int, CaseIterable, Equatable, Identifiable {

    case database = 0
    case nswitch = 130
    case windows = 6
    case xboxxs = 169
    case ps3 = 9
    case ps4 = 48
    case ps5 = 167
    case android = 34
    case iOS = 39
    case mac = 14
    case xone = 49
    case linux = 3
    case nintendo3DS = 37
    case newNintendo3DS = 137
    case nintendoWii = 5
    case nintendoWiiU = 41
    case oculusQuest = 384
    
    var id: Int {
        switch self {
        default:
            return self.rawValue
        }
    }
    
    var platformId: String {
        switch self {
        case .database:
            return ""
        default:
            return String(self.rawValue)
        }
    }
    
    var title: String {
        switch self {
        case .nswitch:
            return "Nintendo Switch"
        case .windows:
            return "Windows"
        case .xboxxs:
            return "Xbox Series S/X"
        case .ps3:
            return "PS3"
        case .ps4:
            return "PS4"
        case .ps5:
            return "PS5"
        case .android:
            return "Android"
        case .iOS:
            return "iOS"
        case .mac:
            return "Mac"
        case .xone:
            return "Xbox One"
        case .linux:
            return "Linux"
        case .nintendo3DS:
            return "Nintendo 3DS"
        case .newNintendo3DS:
            return "New Nintendo 3DS"
        case .nintendoWii:
            return "Nintendo Wii"
        case .nintendoWiiU:
            return "Nintendo Wii U"
        case .oculusQuest:
            return "Oculus Quest"
        case .database:
            return "Platforms"
        }
    }
    
    var assetName: String {
        switch self {
        case .ps4:
            return "ps4"
        case .nswitch:
            return "switch"
        case .windows:
            return "windows"
        case .xboxxs:
            return "xboxs"
        case .ps3:
            return "ps3"
        case .ps5:
            return "ps5"
        case .android:
            return "android"
        case .iOS:
            return "ios"
        case .mac:
            return "mac"
        case .xone:
            return "xboxo"
        case .linux:
            return "linux"
        case .nintendo3DS:
            return "nintendo-3ds"
        case .newNintendo3DS:
            return "nintendo-3ds"
        case .nintendoWii:
            return "nintendo-wii"
        case .nintendoWiiU:
            return "nintendo-wii-u-96"
        case .oculusQuest:
            return "oculus"
        case .database:
            return "filter"
        }
    }
}
