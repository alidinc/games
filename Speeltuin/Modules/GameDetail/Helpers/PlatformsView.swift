//
//  PlatformsView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/12/2023.
//

import SwiftUI


struct PlatformsView: View {
    
    var game: Game
    
    var body: some View {
        if let platforms = game.platforms, !platforms.isEmpty {
            VStack(alignment: .leading) {
                Text("Platforms")
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(platforms, id: \.self) { platform in
                            if let id = platform.id, let popularPlatform = PopularPlatform(rawValue: id) {
                                if let releaseDates = game.releaseDates,
                                   let platformDate = releaseDates.first(where: { $0.platform == platform.id }) {
                                    if let _ = platformDate.date {
                                        CapsuleView(title: popularPlatform.title,
                                                    imageType: .asset,
                                                    imageName: popularPlatform.assetName)
                                    } else {
                                        CapsuleView(title: "N/A")
                                    }
                                }
                            } else {
                                if let name = platform.name {
                                    CapsuleView(title: name)
                                }
                            }
                        }
                    }
                }
                .fadeOutSides(side: .trailing)
                .frame(maxWidth: .infinity)
            }
            .hSpacing(.leading)
        }
    }
}
