//
//  DidRemoteChange.swift
//  Speeltuin
//
//  Created by alidinc on 03/02/2024.
//

import Foundation

var didRemoteChange = NotificationCenter
    .default
    .publisher(for: .NSPersistentStoreRemoteChange)
    .receive(on: RunLoop.main)
