//
//  DataType.swift
//  Spellen
//
//  Created by alidinc on 19/01/2024.
//

import Foundation

enum DataType: String, CaseIterable {
    case network
    case library
}

enum FilterType {
    case search
    case library
    case genre
    case platform
}
