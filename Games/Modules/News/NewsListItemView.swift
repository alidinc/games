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

    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @Query private var savedNews: [SPNews]
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title = item.title {
                Text(title)
                    .foregroundStyle(.primary)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }

            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading) {
                    if let media = item.media, let mediaContents = media.mediaContents,
                       let content = mediaContents.first, let attributes = content.attributes, let urlString = attributes.url {
                        AsyncImageView(with: urlString, type: .news)
                            .shadow(radius: 4)
                    }

                    if let pubDate = item.pubDate {
                        Text(pubDate, format: .dateTime.day().month().year().hour().minute())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if let description = item.description, let desc = description.htmlToString() {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(6, reservesSpace: true)
                }
            }
        }
        .padding(8)
        .frame(width: UIScreen.main.bounds.size.width - 20)
        .glass()
        .alert(Constants.Alert.alreadySaved, isPresented: $showAlert) {
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
            Text(Constants.Alert.alreadySavedMessage)
        }
    }
}
