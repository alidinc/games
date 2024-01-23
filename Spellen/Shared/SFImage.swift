//
//  SFImage.swift
//  JustGames
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftUI

struct SFImage: View {
    
    var name: String
    var config: SFConfig
    
    init(name: String, config: SFConfig = .init()) {
        self.name = name
        self.config = config
    }
    
    var body: some View {
        Image(systemName: name)
            .symbolEffect(.bounce, value: config.color)
            .symbolEffect(.bounce, value: name)
            .frame(width: config.size, height: config.size)
            .padding(config.padding)
            .font(.system(size: config.size))
            .foregroundStyle(config.color)
            .background(Color.black.opacity(config.opacity), in: .rect(cornerRadius: config.radius))
    }
}

struct SFConfig {
    let opacity: CGFloat
    let radius: CGFloat
    let padding: CGFloat
    let color: Color
    let size: CGFloat
    
    init(
        opacity: CGFloat = 0.5,
        radius: CGFloat = 8,
        padding: CGFloat = 10,
        color: Color = .primary,
        size: CGFloat = 24
    ) {
        self.opacity = opacity
        self.radius = radius
        self.padding = padding
        self.color = color
        self.size = size
    }
}
