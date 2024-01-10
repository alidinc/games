//
//  NewsView.swift
//  JustGames
//
//  Created by Ali Dinç on 06/01/2024.
//

import FeedKit
import SwiftUI
import SafariServices

struct NewsView: View {
    
    @State var vm = NewsViewModel()
    @State var presentLink = false
    @State var selectedItem: RSSFeedItem?
    
    @AppStorage("appTint") var appTint: Color = .white
    @Environment(Preferences.self) private var preferences: Preferences
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView
                GameNewsListView
            }
            .background(.gray.opacity(0.15))
            .task(id: vm.newsType, {
                await vm.fetchNews()
            })
        }
    }
    
    @ViewBuilder
    var LoadingView: some View {
        if preferences.networkStatus == .local {
            ContentUnavailableView(
                "No network available",
                systemImage: "exclamationmark.triangle.fill",
                description: Text(
                    "We are unable to display any content as your iPhone is not currently connected to the internet."
                )
            )
        } else {
            if vm.news.isEmpty {
                ZStack {
                    ProgressView("Please wait, \nwhile we are getting ready! ☺️")
                        .font(.subheadline)
                        .tint(.white)
                        .multilineTextAlignment(.center)
                        .controlSize(.large)
                }
                .hSpacing(.center)
                .padding(.horizontal, 50)
                .ignoresSafeArea()
            }
        }
    }
    
    var HeaderView: some View {
        HStack(alignment: .center, spacing: 4) {
            Menu {
                Picker("", selection: $vm.newsType) {
                    ForEach(NewsType.allCases, id: \.id) { news in
                        Text(news.title).tag(news)
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    SFImage(name: "newspaper.fill", opacity: 0, radius: 0, padding: 0, color: appTint)
                    
                    Text(vm.newsType.title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.primary)
                        .shadow(radius: 10)
                }
                
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
            }

            
            
            Spacer()
            
            HStack(alignment: .bottom) {
                Text("Today")
                    .font(.headline.bold())
                    .foregroundStyle(.primary)
                
                Text(Date.now.asString(style: .medium))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(appTint)
        .padding(.horizontal)
        .padding(.top)
    }
    
    var GameNewsListView: some View {
        List {
            ForEach(groupedAndSortedItems(rssFeedItems: vm.news), id: \.0) { section, items in
                Section {
                    ForEach(items, id: \.guid?.value) { item in
                        Button {
                            selectedItem = item
                        } label: {
                            NewsView(item: item)
                        }
                        .sheet(item: $selectedItem, content: { item in
                            if let urlString = item.link, let url = URL(string: urlString) {
                                SFSafariView(url: url)
                                    .background(.gray.opacity(0.15))
                                    .navigationTitle(item.title ?? "")
                                    .ignoresSafeArea()
                            }
                        })
                    }
                } header: {
                    Text(section)
                        .font(.headline)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .padding(.bottom, 5)
        .overlay {
            LoadingView
        }
    }
    
    
    private func groupedAndSortedItems(rssFeedItems: [RSSFeedItem]) -> [(String, [RSSFeedItem])] {
        let groupedItems = Dictionary(grouping: rssFeedItems) { item in
            // Customize the date format based on your needs
            let dateFormatter = DateFormatter()
            //  dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: item.pubDate ?? Date())
        }
        
        return groupedItems.sorted(by: { $0.0 > $1.0 })
    }
    
    
    @ViewBuilder
    func NewsView(item: RSSFeedItem) -> some View {
        VStack(alignment: .leading) {
            if let media = item.media, let mediaContents = media.mediaContents,
               let content = mediaContents.first, let attributes = content.attributes, let urlString = attributes.url {
                AsyncImageView(with: urlString, type: .news)
            }
            
            if let title = item.title {
                Text(title)
                    .font(.headline.bold())
                    .padding(.bottom)
                    .hSpacing(.leading)
            }
            
            if let description = item.description, let desc = description.htmlToString() {
                Text(desc)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(4, reservesSpace: true)
            }
        }
        .padding(12)
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
        .shadow(radius: 4)
        .frame(maxHeight: .infinity)
    }
}

extension RSSFeedItem: Identifiable {
    
}
