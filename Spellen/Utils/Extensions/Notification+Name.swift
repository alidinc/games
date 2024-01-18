//
//  Notification+Name.swift
//  JustGames
//
//  Created by Ali Dinç on 02/01/2024.
//

import Foundation


public extension Notification.Name {
    
    static let viewTypeChanged = Notification.Name("viewTypeChanged")
    static let addedToLibrary = Notification.Name("addedToLibrary")
    static let newLibraryButtonTapped = Notification.Name("newLibraryButtonTapped")
}
