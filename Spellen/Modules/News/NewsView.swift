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
    @Environment(Admin.self) private var preferences: Admin
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView
                GameNewsListView
            }
            .background(.gray.opacity(0.15))
            .task {
                await vm.fetchNews()
            }
            .onChange(of: vm.newsType) { oldValue, newValue in
                switch newValue {
                case .all:
                    vm.allNews = vm.nintendo + vm.xbox + vm.ign
                case .ign:
                    vm.allNews = vm.ign
                case .nintendo:
                    vm.allNews = vm.nintendo
                case .xbox:
                    vm.allNews = vm.xbox
                }
            }
        }
    }
    
    @ViewBuilder
    var LoadingView: some View {
        switch preferences.networkStatus {
        case .available:
            if vm.allNews.isEmpty {
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
        case .unavailable:
            ContentUnavailableView(
                "No network available",
                systemImage: "exclamationmark.triangle.fill",
                description: Text(
                    "We are unable to display any content as your iPhone is not currently connected to the internet."
                )
            )
        }
    }
    
    var HeaderView: some View {
        HStack {
            Menu {
                Picker("", selection: $vm.newsType) {
                    ForEach(NewsType.allCases, id: \.id) { news in
                        Text(news.title).tag(news)
                    }
                }
            } label: {
                HStack {
                    SFImage(name: "newspaper.fill", opacity: 0, radius: 0, padding: 0, color: appTint)
                    
                    Text(vm.newsType.title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.primary)
                        .shadow(radius: 10)
                    
                    Image(systemName: "chevron.down")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.primary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
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
            ForEach(groupedAndSortedItems(rssFeedItems: vm.allNews), id: \.0) { section, items in
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
        .id(UUID().uuidString)
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
                    .padding(.top, 4)
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
        .padding(12)
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
        .shadow(radius: 4)
        .frame(maxHeight: .infinity)
    }
}

extension RSSFeedItem: Identifiable {
    
}
