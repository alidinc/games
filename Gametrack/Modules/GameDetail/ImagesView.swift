//
//  ImagesView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct ImagesView: View {
    
    var game: Game
    
    @ViewBuilder
    var body: some View {
        if game.imageURLs.isEmpty, let cover = game.cover, let url = cover.url {
            AsyncImageView(with: url, type: .detail)
        } else {
            TabView {
                ForEach(game.imageURLs, id: \.self) { screenshotURL in
                    AsyncImageView(with: screenshotURL, type: .detail)
                        .tag(screenshotURL)
                }
                .cornerRadius(10)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: UIScreen.main.bounds.size.height * 0.6)
        }
    }
}
