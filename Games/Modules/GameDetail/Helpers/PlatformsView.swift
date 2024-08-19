//
//  PlatformsView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/12/2023.
//

import SwiftUI

import SwiftUI

struct PlatformsView: View {

    var game: Game

    var body: some View {
        if let platforms = game.platforms, !platforms.isEmpty {
            Divider()

            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(platforms, id: \.self) { platform in
                            if let id = platform.id, let popularPlatform = PopularPlatform(rawValue: id) {
                                // Find the most recent release date for the current platform
                                if let platformDate = game.releaseDates?
                                    .filter({ $0.platform == platform.id }) // Filter dates for the current platform
                                    .sorted(by: { ($0.date ?? 0) < ($1.date ?? 0) }) // Sort dates in descending order
                                    .first(where: { $0.date != nil }) // Get the most recent non-nil date
                                {
                                    CapsuleView(title: popularPlatform.title,
                                                subtitle: platformDate.human ?? "",
                                                imageType: .asset,
                                                imageName: popularPlatform.assetName)
                                } else {
                                    CapsuleView(title: popularPlatform.title,
                                                subtitle: "N/A",
                                                imageType: .sf,
                                                imageName: "")
                                }
                            } else {
                                if let name = platform.name {
                                    CapsuleView(title: name, imageType: .sf)
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
