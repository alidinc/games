//
//  DataFetchPhase.swift
//  Speeltuin
//
//  Created by Ali Dinç on 26/11/2022.
//

import Foundation

enum DataFetchPhase<T: Equatable>: Equatable {
    
    case empty
    case loading
    case success(T)
    case fetchingNextPage(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        } else if case .fetchingNextPage(let value) = self {
            return value
        }
        return nil
    }
    
    static func == (lhs: DataFetchPhase<T>, rhs: DataFetchPhase<T>) -> Bool {
        return lhs.value == rhs.value
    }
}
