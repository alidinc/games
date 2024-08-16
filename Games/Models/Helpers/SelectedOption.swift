//
//  SelectedOption.swift
//  Speeltuin
//
//  Created by alidinc on 31/01/2024.
//

import Foundation

enum SelectionOption: String, CaseIterable, Identifiable {
    case platform
    case genre
    
    var id: String {
        switch self {
        default:
            UUID().uuidString
        }
    }
}
