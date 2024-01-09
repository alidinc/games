//
//  NetworkMonitor.swift
//  JustGames
//
//  Created by Ali Dinç on 03/01/2024.
//

import Network
import SwiftUI

@Observable
class NetworkMonitor {
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue

    var isConnected: Bool = true

    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitor")

        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.isConnected = true
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.isConnected = false
                }
            }
        }

        monitor.start(queue: queue)
    }
}
