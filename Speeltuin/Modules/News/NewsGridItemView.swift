//
//  NewsGridItemView.swift
//  Speeltuin
//
//  Created by alidinc on 25/01/2024.
//

import FeedKit
import SwiftUI
import SwiftData

struct NewsGridItemView: View {
    
    var onSelect: () -> Void
    var item: RSSFeedItem
    let dataManager: DataManager
    
    @Query private var savedNews: [SPNews]
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    
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
                            .font(.system(size: 12, weight: .semibold))
                            .multilineTextAlignment(.leading)
                            .lineLimit(4)
                            .padding(.horizontal, 4)
                            .padding(.bottom, 6)
                            .foregroundStyle(.white)
                    }
                    .clipShape(.rect(cornerRadius: 5))
                }
            }
        }
        .contextMenu(menuItems: {
            if let title = item.title,
               let link = item.link,
               let details = item.description,
               let detailsDecoded = details.htmlToString(),
               let pubDate = item.pubDate {
                
                let news = SPNews(
                    title: title,
                    link: link,
                    details: detailsDecoded,
                    pubDate: pubDate
                )
                
                if !self.savedNews.compactMap({$0.title}).contains(news.title) {
                    Button("Save") {
                        Task {
                            await dataManager.addNews(news: news)
                        }
                        
                        if hapticsEnabled {
                            HapticsManager.shared.vibrateForSelection()
                        }
                    }
                }
                
                if self.savedNews.compactMap({$0.title}).contains(news.title) {
                    Button("Delete", role: .destructive) {
                        if let newsToDelete = savedNews.first(where: {$0.title == item.title }) {
                            modelContext.delete(newsToDelete)
                        }
                    }
                }
            }
        })
    }
}
