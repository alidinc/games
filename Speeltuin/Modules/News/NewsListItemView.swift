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
    @Environment(\.colorScheme) var colorScheme
    
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
                        .foregroundStyle(.primary)
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
        }
        .padding(12)
        .frame(width: UIScreen.main.bounds.size.width - 20)
        .background(colorScheme == .dark ? .ultraThinMaterial : .ultraThick, in: .rect(cornerRadius: 20))
        .shadow(radius: 4)
    }
}
