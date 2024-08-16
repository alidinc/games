//
//  ImagesView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct ImagesView: View {
    
    var game: Game
    
    var imageURLs: [String] {
        guard let artworks = self.game.artworks,
              let screenshots = self.game.screenshots,
              let cover = self.game.cover,
              let url = cover.url else {
            return []
        }
        
        let coverUrl = [url]
        let artworkURLs = artworks.compactMap({$0.url})
        let screenshotURLs = screenshots.compactMap({$0.url})
        
        return coverUrl + artworkURLs + screenshotURLs
    }
   
    @ViewBuilder
    var body: some View {
        if self.imageURLs.isEmpty, let cover = game.cover, let url = cover.url {
            AsyncImageView(with: url, type: .detail)
        } else {
            TabView {
                ForEach(self.imageURLs, id: \.self) { screenshotURL in
                    AsyncImageView(with: screenshotURL, type: .detail)
                        .tag(screenshotURL)
                }
                .cornerRadius(10)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: UIScreen.main.bounds.size.width,
                   height: UIScreen.main.bounds.size.height * 0.6)
        }
    }
}

