//
//  LabelStyle.swift
//  Games
//
//  Created by Ali Dinç on 17/08/2024.
//

import SwiftUI

struct LabelModifier: ViewModifier {

    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        content
            .foregroundStyle(scheme == .dark ? .white : .black)
    }
}

extension View {
    func labelStyle() -> some View {
        self.modifier(LabelModifier())
    }
}
