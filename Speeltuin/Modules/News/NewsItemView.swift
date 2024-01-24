//
//  NewsItemView.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import FeedKit
import SwiftUI

struct NewsItemView: View {
    
    var item: RSSFeedItem

    @AppStorage("appTint") var appTint: Color = .white
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let media = item.media, let mediaContents = media.mediaContents,
               let content = mediaContents.first, let attributes = content.attributes, let urlString = attributes.url {
                AsyncImageView(with: urlString, type: .news)
            }
            
            VStack(alignment: .leading) {
                if let title = item.title {
                    Text(title)
                        .font(.headline.bold())
                        .hSpacing(.leading)
                }
                
                if let description = item.description, let desc = description.htmlToString() {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(4, reservesSpace: true)
                }
                
                if let author = item.author {
                    Text(author)
                        .font(.caption)
                        .foregroundStyle(appTint)
                        .hSpacing(.trailing)
                } else if let dublin = item.dublinCore, let author = dublin.dcCreator {
                    HStack(alignment: .bottom) {
                        if let date = item.pubDate {
                            Text(date.asString(style: .medium))
                                .foregroundStyle(.gray.opacity(0.5))
                        }
                        
                        Spacer()
                        
                        Text("by \(author)")
                            .foregroundStyle(appTint.opacity(0.5))
                    }
                    .font(.caption)
                    .padding(.top)
                }
            }
        }
        .padding(12)
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
        .shadow(radius: 4)
        .frame(maxHeight: .infinity)
    }
}
