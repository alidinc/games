//
//  Task+Extension.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
