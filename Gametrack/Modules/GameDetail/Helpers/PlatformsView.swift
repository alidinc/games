//
//  PlatformsView.swift
//  Gametrack
//
//  Created by Ali Dinç on 22/12/2023.
//

import SwiftUI


struct PlatformsView: View {
    
    var game: Game
    
    var body: some View {
        if let platforms = game.platforms, !platforms.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(platforms, id: \.self) { platform in
                        if let popularPlatform = platform.platform {
                            Image(popularPlatform.assetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                        }
                    }
                }
            }
        }
    }
}
