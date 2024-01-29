//
//  NewsItemView.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import FeedKit
import SwiftUI
import SwiftData

struct NewsListItemView: View {
    
    var item: RSSFeedItem
    let dataManager: DataManager

    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @Query private var savedNews: [SPNews]
    @State private var showAlert = false
    
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
                        .lineLimit(4, reservesSpace: true)
                }
                
                if let description = item.description, description.isEmpty {
                    Spacer().frame(height: 20)
                }
                
                HStack(alignment: .bottom) {
                    if let description = item.description, let desc = description.htmlToString() {
                        Text(desc)
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .lineLimit(4, reservesSpace: true)
                    }
                    
                    Spacer()
                    
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
                        
                        Button {
                            if !self.savedNews.compactMap({$0.title}).contains(news.title) {
                                Task {
                                    await dataManager.addNews(news: news)
                                }
                                
                                if hapticsEnabled {
                                    HapticsManager.shared.vibrateForSelection()
                                }
                            } else {
                               showAlert = true
                            }
                        } label: {
                            if !self.savedNews.compactMap({$0.title}).contains(news.title) {
                                SFImage(name: "bookmark")
                            } else {
                                SFImage(name: "bookmark.fill")
                            }
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(width: UIScreen.main.bounds.size.width - 20)
        .background(colorScheme == .dark ? .ultraThinMaterial : .ultraThick, in: .rect(cornerRadius: 20))
        .shadow(radius: colorScheme == .dark ? 4 : 2)
        .alert("It's already saved!", isPresented: $showAlert) {
            Button(role: .destructive) {
                if let newsToDelete = savedNews.first(where: {$0.title == item.title }) {
                    modelContext.delete(newsToDelete)
                }
                
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
            } label: {
                Text("Delete")
            }

            Button(role: .cancel) {
                
            } label: {
                Label("Cancel", systemImage: "checkmark")
            }
        } message: {
            Text("Would you like to delete it?")
        }
    }
}
