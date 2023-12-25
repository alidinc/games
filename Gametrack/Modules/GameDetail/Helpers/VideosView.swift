//
//  VideosView.swift
//  Gametrack
//
//  Created by Ali Dinç on 24/12/2023.
//

import SwiftUI
import AVKit

struct VideosView: View {
    
    var game: Game
    
    var body: some View {
        if !game.videoURLs.isEmpty {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(game.videoURLs, id: \.self) { id in
                        YoutubeVideoView(youtubeVideoID: id)
                    }
                    .frame(width: 300, height: 170)
                    .clipShape(.rect(cornerRadius: 8))
                }
                .padding(.vertical)
            }
        }
    }
}


import SwiftUI
import WebKit

struct YoutubeVideoView: UIViewRepresentable {
    
    @State var youtubeVideoID: String
    
    func makeUIView(context: Context) -> WKWebView  {
        let configuration = WKWebViewConfiguration()
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.allowsInlineMediaPlayback = false
        return WKWebView(frame: .zero, configuration: configuration)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        let path = "https://www.youtube.com/embed/\(youtubeVideoID)"
        guard let url = URL(string: path) else { return }
        let request = URLRequest(url: url)
        
        webView.scrollView.isScrollEnabled = false
        webView.load(request)
    }
}
