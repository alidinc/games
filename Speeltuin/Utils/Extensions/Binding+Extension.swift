//
//  Binding+Extension.swift
//  GameLob
//
//  Created by Ali Dinç on 15/01/2024.
//

import SwiftUI

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy { source.wrappedValue = nil }
                else { source.wrappedValue = newValue }
            }
        )
    }
}
