//
//  CacheEntry.swift
//  Gameraw
//
//  Created by Ali Dinç on 26/11/2022.
//

import Foundation

final class CacheEntry<V> {
    
    let key: String
    let value: V
    let expiredTimestamp: Date
    
    init(key: String, value: V, expiredTimestamp: Date) {
        self.key = key
        self.value = value
        self.expiredTimestamp = expiredTimestamp
    }
    
    func isCacheExpired(after date: Date = .now) -> Bool {
        date > self.expiredTimestamp
    }
}

extension CacheEntry: Codable where V: Codable {}
