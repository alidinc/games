//
//  SFImage.swift
//  Speeltuin
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftUI

struct SFImage: View {

    var config: SFConfig
    
    var body: some View {
        Image(systemName: config.name)
            .frame(width: config.size, height: config.size)
            .padding(config.padding)
            .font(.system(size: config.iconSize))
            .bold(config.isBold)
            .foregroundStyle(config.color)
            .contentTransition(.symbolEffect)
    }
}

struct SFConfig {
    let name: String
    let padding: CGFloat
    let color: Color
    let size: CGFloat
    let iconSize: CGFloat
    let isBold: Bool
    
    init(
        name: String,
        padding: CGFloat = 10,
        color: Color = .primary,
        size: CGFloat = 24,
        iconSize: CGFloat = 20,
        isBold: Bool = false
    ) {
        self.name = name
        self.padding = padding
        self.color = color
        self.size = size
        self.iconSize = iconSize
        self.isBold = isBold
    }
}
