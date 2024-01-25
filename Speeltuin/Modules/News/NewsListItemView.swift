//
//  NewsItemView.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import FeedKit
import SwiftUI

struct NewsListItemView: View {
    
    var item: RSSFeedItem

    @AppStorage("appTint") var appTint: Color = .white
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let media = item.media, let mediaContents = media.mediaContents,
               let content = mediaContents.first, let attributes = content.attributes, let urlString = attributes.url {
                AsyncImageView(with: urlString, type: .news)
                    .shadow(radius: 4)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                if let title = item.title {
                    Text(title)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                }
                
                if let description = item.description, let desc = description.htmlToString() {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .lineLimit(4, reservesSpace: true)
                }
            }
            .vSpacing(.top)
        }
        .padding(12)
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
        .frame(maxHeight: .infinity)
        .shadow(radius: 4)
    }
}
