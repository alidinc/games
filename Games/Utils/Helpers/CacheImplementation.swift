//
//  CacheImplementation.swift
//  Speeltuin
//
//  Created by Ali Dinç on 26/11/2022.
//

import Foundation

extension TimeInterval {

    var seconds: Int {
        return Int(self.rounded())
    }

    var milliseconds: Int {
        return Int(self * 1_000)
    }
}

fileprivate protocol NSCacheType: Cache {
    var cache: NSCache<NSString, CacheEntry<V>> { get }
    var keysTracker: KeysTracker<V> { get }
}

actor InMemoryCache<V>: NSCacheType {
    
    fileprivate let cache: NSCache<NSString, CacheEntry<V>> = .init()
    fileprivate let keysTracker: KeysTracker<V> = .init()
    
    let expirationInterval: TimeInterval
    
    init(expirationInterval: TimeInterval) {
        self.expirationInterval = expirationInterval
    }
}

actor DiskCache<V: Codable>: NSCacheType {
    
    fileprivate let cache: NSCache<NSString, CacheEntry<V>> = .init()
    fileprivate let keysTracker: KeysTracker<V> = .init()
    
    let filename: String
    let expirationInterval: TimeInterval
    
    init(filename: String, expirationInterval: TimeInterval) {
        self.filename = filename
        self.expirationInterval = expirationInterval
    }
    
    private var saveLocationURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(filename).cache")
    }
    
    func saveToDisk() throws {
        let entries = self.keysTracker.keys.compactMap { self.entry(forKey: $0) }
        
        let data = try JSONEncoder().encode(entries)
        try data.write(to: self.saveLocationURL)
    }
    
    func loadFromDisk() throws {
        let data = try Data(contentsOf: self.saveLocationURL)
        let entries = try JSONDecoder().decode([CacheEntry<V>].self, from: data)
        entries.forEach { self.insert($0) }
    }
}

extension NSCacheType {
    
    func removeValue(forKey key: String) {
        self.keysTracker.keys.remove(key)
        self.cache.removeObject(forKey: key as NSString)
    }
    
    func removeAllValues() {
        self.keysTracker.keys.removeAll()
        self.cache.removeAllObjects()
    }
    
    func setValue(_ value: V?, forKey key: String) {
        if let value {
            let expiredTimestamp = Date().addingTimeInterval(self.expirationInterval)
            let cacheEntry = CacheEntry(key: key, value: value, expiredTimestamp: expiredTimestamp)
            
            self.insert(cacheEntry)
        } else {
            self.removeValue(forKey: key)
        }
    }
    
    func value(forKey key: String) -> V? {
        self.entry(forKey: key)?.value
    }
    
    func entry(forKey key: String) -> CacheEntry<V>? {
        guard let entry = self.cache.object(forKey: key as NSString) else {
            return nil
        }
        
        guard !entry.isCacheExpired(after: Date()) else {
            self.removeValue(forKey: key)
            return nil
        }
        
        return entry
    }
    
    func insert(_ entry: CacheEntry<V>) {
        self.keysTracker.keys.insert(entry.key)
        self.cache.setObject(entry, forKey: entry.key as NSString)
    }
}
