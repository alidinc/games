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
            VStack(alignment: .leading) {
                Text("Platforms")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(platforms, id: \.self) { platform in
                            if let popularPlatform = platform.popularPlatform {
                                VStack(alignment: .center, spacing: 8) {
                                    Image(popularPlatform.assetName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        
                                    
                                    if let releaseDates = game.releaseDates {
                                        if let platformDate = releaseDates.first(where: { $0.platform == platform.id }),
                                           let timeIntervalDate = platformDate.date {
                                            Text(timeIntervalDate.numberToYear())
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        } else {
                                            Text("N/A")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                                .padding(10)
                                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                            } else {
                                if let name = platform.name {
                                    VStack(alignment: .center, spacing: 8) {
                                        Text(name)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        
                                        if let releaseDates = game.releaseDates {
                                            if let platformDate = releaseDates.first(where: { $0.platform == platform.id }),
                                               let timeIntervalDate = platformDate.date {
                                                Text(timeIntervalDate.numberToYear())
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                            } else {
                                                Text("N/A")
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
