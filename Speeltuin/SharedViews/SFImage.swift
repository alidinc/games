//
//  SFImage.swift
//  Speeltuin
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftUI

struct SFImage: View {
    
    @Binding var updatingName: String?
    var name: String? = nil
    var config: SFConfig
    
    @Environment(\.colorScheme) var colorScheme

    init(updatingName: Binding<String?> = .constant(nil), name: String? = nil, config: SFConfig = .init()) {
        self._updatingName = updatingName
        self.name = name
        self.config = config
    }
    
    var body: some View {
        if let name {
            Image(systemName: name)
                .symbolEffect(.bounce, value: name)
                .frame(width: config.size, height: config.size)
                .padding(config.padding)
                .font(.system(size: config.iconSize))
                .bold(config.isBold)
                .foregroundStyle(config.color)
                .background(colorScheme == .dark ? .black.opacity(config.opacity) : .gray.opacity(config.opacity), in: .rect(cornerRadius: config.radius))
        } else if let updatingName {
            Image(systemName: updatingName)
                .symbolEffect(.bounce, value: updatingName)
                .frame(width: config.size, height: config.size)
                .padding(config.padding)
                .font(.system(size: config.iconSize))
                .bold(config.isBold)
                .foregroundStyle(config.color)
                .background(colorScheme == .dark ? .black.opacity(config.opacity) : .gray.opacity(config.opacity), in: .rect(cornerRadius: config.radius))
        }
        
    }
}

struct SFConfig {
    let opacity: CGFloat
    let radius: CGFloat
    let padding: CGFloat
    let color: Color
    let size: CGFloat
    let iconSize: CGFloat
    let isBold: Bool
    
    init(
        opacity: CGFloat = 0.5,
        radius: CGFloat = 8,
        padding: CGFloat = 10,
        color: Color = .primary,
        size: CGFloat = 24,
        iconSize: CGFloat = 20,
        isBold: Bool = false
    ) {
        self.opacity = opacity
        self.radius = radius
        self.padding = padding
        self.color = color
        self.size = size
        self.iconSize = iconSize
        self.isBold = isBold
    }
}
