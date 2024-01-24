//
//  UIDevice+Extension.swift
//  GameLob
//
//  Created by alidinc on 16/01/2024.
//

import Foundation
import UIKit

struct ScreenSize { // Answer to OP's question
    
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    
}

struct DeviceType { //Use this to check what is the device kind you're working with
    
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_SE         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_7PLUS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_14      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 844.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    
    static let isSmallScreen = IS_IPHONE_SE || IS_IPHONE_7 || IS_IPHONE_4_OR_LESS
}


struct iOSVersion { //Get current device's iOS version
    
    static let SYS_VERSION_FLOAT  = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7               = (iOSVersion.SYS_VERSION_FLOAT >= 7.0 && iOSVersion.SYS_VERSION_FLOAT < 8.0)
    static let iOS8               = (iOSVersion.SYS_VERSION_FLOAT >= 8.0 && iOSVersion.SYS_VERSION_FLOAT < 9.0)
    static let iOS9               = (iOSVersion.SYS_VERSION_FLOAT >= 9.0 && iOSVersion.SYS_VERSION_FLOAT < 10.0)
    static let iOS10              = (iOSVersion.SYS_VERSION_FLOAT >= 10.0 && iOSVersion.SYS_VERSION_FLOAT < 11.0)
    static let iOS11              = (iOSVersion.SYS_VERSION_FLOAT >= 11.0 && iOSVersion.SYS_VERSION_FLOAT < 12.0)
    static let iOS12              = (iOSVersion.SYS_VERSION_FLOAT >= 12.0 && iOSVersion.SYS_VERSION_FLOAT < 13.0)
    static let iOS13              = (iOSVersion.SYS_VERSION_FLOAT >= 13.0 && iOSVersion.SYS_VERSION_FLOAT < 14.0)
    static let iOS14              = (iOSVersion.SYS_VERSION_FLOAT >= 14.0 && iOSVersion.SYS_VERSION_FLOAT < 15.0)
    static let iOS15              = (iOSVersion.SYS_VERSION_FLOAT >= 15.0 && iOSVersion.SYS_VERSION_FLOAT < 16.0)
    
}
