//
//  SFImage.swift
//  JustGames
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftUI

struct SFImage: View {
    
    var name: String
    var opacity: CGFloat
    var radius: CGFloat
    var padding: CGFloat
    var color: Color
    
    init(
        name: String,
        opacity: CGFloat = 0.5,
        radius: CGFloat = 8,
        padding: CGFloat = 10,
        color: Color = .primary
    ) {
        self.name = name
        self.opacity = opacity
        self.radius = radius
        self.padding = padding
        self.color = color
    }
    
    var body: some View {
        Image(systemName: name)
            .symbolEffect(.bounce, value: color)
            .symbolEffect(.bounce, value: name)
            .imageScale(.medium)
            .frame(width: 24, height: 24)
            .padding(padding)
            .foregroundStyle(color)
            .background(Color.black.opacity(opacity), in: .rect(cornerRadius: radius))
    }
}
