//
//  Cache.swift
//  JustGames
//
//  Created by Ali Dinç on 26/11/2022.
//

import Foundation

protocol Cache: Actor {
    associatedtype V
    var expirationInterval: TimeInterval { get }
    func removeValue(forKey key: String)
    func removeAllValues()
    func setValue(_ value: V?, forKey key: String)
    func value(forKey key: String) -> V?
}
