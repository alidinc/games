//
//  SFImage.swift
//  Speeltuin
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftUI

struct SFImage: View {
    
    @State var name: String
    var config: SFConfig = .init()
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    
    var body: some View {
        Image(systemName: name)
            .symbolEffect(.bounce, value: name)
            .frame(width: config.size, height: config.size)
            .padding(config.padding)
            .font(.system(size: config.iconSize))
            .bold(config.isBold)
            .foregroundStyle(config.color)
            .background(Color.sfButtonBackground.opacity(config.opacity), in: .rect(cornerRadius: config.radius))
            .onChange(of: name) { oldValue, newValue in
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
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
