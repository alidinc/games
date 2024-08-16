//
//  SocialsView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct SocialsView: View {
    
    var game: Game
    
    var body: some View {
        if let websites = game.websites, !websites.isEmpty {
            VStack(alignment: .leading) {
                Text("Links")
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        ForEach(websites, id: \.id) { website in
                            if let url = website.url,
                               let websiteURL = URL(string: url),
                               let category = website.category,
                               let platform = PlatformWebsite(rawValue: category) {
                                Link(destination: websiteURL) {
                                    CapsuleView(
                                        title: platform.title,
                                        imageType: platform == .official ? .sf : .asset,
                                        imageName: platform.imageName
                                    )
                                }
                                .tint(.primary)
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
