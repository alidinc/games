//
//  Feedback+Enum.swift
//  Speeltuin
//
//  Created by Ali Dinc on 22/02/2023.
//

import SwiftUI

enum Feedback: Int, CaseIterable, Equatable, Hashable {
    case email
    case rate
    case share
    
    var id: Int {
        switch self {
        default:
            return self.rawValue
        }
    }
    
    var title: String {
        switch self {
        case .email:
            return "Support"
        case .rate:
            return "Rate us"
        case .share:
            return "Share"
        }
    }
    
    var imageName: String {
        switch self {
        case .email:
            return "paperplane.circle.fill"
        case .rate:
            return "heart.circle.fill"
        case .share:
            return "square.and.arrow.up.circle.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .email:
            return Color.teal
        case .rate:
            return Color.cyan
        case .share:
            return Color.blue
        }
    }
}
