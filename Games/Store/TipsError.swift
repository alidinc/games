//
//  TipsError.swift
//  GoodGames
//
//  Created by Ali Dinc on 16/02/2023.
//

import Foundation

enum TipsError: LocalizedError {
    case failedVerification
    case system(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "User transaction verification failed"
        case .system(let error):
            return error.localizedDescription
        }
    }
}
