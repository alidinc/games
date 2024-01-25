//
//  NewsGridItemView.swift
//  Speeltuin
//
//  Created by alidinc on 25/01/2024.
//

import FeedKit
import SwiftUI

struct NewsGridItemView: View {
    
    var onSelect: () -> Void
    
    var item: RSSFeedItem
    
    var body: some View {
        Button {
            onSelect()
        } label: {
            if let media = item.media,
               let mediaContents = media.mediaContents,
               let content = mediaContents.first,
               let attributes = content.attributes,
               let urlString = attributes.url {
                
                
                if let title = item.title {
                    ZStack(alignment: .bottom) {
                        AsyncImageView(with: urlString, type: .gridNews)
                        
                        
                        LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                            .clipShape(.rect(cornerRadius: 5))
                        
                        Text(title)
                            .font(.system(size: 10, weight: .semibold))
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .padding(.horizontal, 4)
                            .padding(.bottom, 6)
                    }
                    .clipShape(.rect(cornerRadius: 5))
                }
            }
        }
    }
}
