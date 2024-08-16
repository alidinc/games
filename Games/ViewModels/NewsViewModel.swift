//
//  NewsViewModel.swift
//  Speeltuin
//
//  Created by Ali Dinç on 06/01/2024.
//

import SwiftUI
import Observation
import FeedKit
import Combine

@Observable
class NewsViewModel {

    var news = [RSSFeedItem]()
    var newsType: NewsType = .all {
        didSet {
            Task {
                await fetchNews()
            }
        }
    }

    init() {
        Task {
            await fetchNews()
        }
    }

    func groupNews(items: [RSSFeedItem]) -> [(Date, [RSSFeedItem])] {
        let groupedItems = Dictionary(grouping: items) { item in
            return Calendar.current.startOfDay(for: (item.pubDate ?? .now))
        }

        return groupedItems.sorted(by: { $0.0 > $1.0 })
    }

    func fetchNews() async {
        if newsType == .all {
            await fetchAllNews()
        } else {
            await fetchNews(from: newsType.urlString)
        }
    }

    private func fetchAllNews() async {
        let urls = NewsType.allCases.filter { $0 != .all }.map { $0.urlString }

        var allNews = [RSSFeedItem]()

        await withTaskGroup(of: [RSSFeedItem].self) { group in
            for url in urls {
                group.addTask {
                    return await self.fetchNews(from: url)
                }
            }

            for await items in group {
                allNews.append(contentsOf: items)
            }
        }

        self.news = allNews.sorted { ($0.pubDate ?? Date()) > ($1.pubDate ?? Date()) }
    }

    private func fetchNews(from urlString: String) async -> [RSSFeedItem] {
        guard let url = URL(string: urlString) else {
            return []
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try await parseFeed(data: data)

            if self.newsType != .all {
                self.news = items
            }
            return items
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    private func parseFeed(data: Data) async throws -> [RSSFeedItem] {
        try await withCheckedThrowingContinuation { continuation in
            let parser = FeedParser(data: data)
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    let items = feed.rssFeed?.items ?? []
                    continuation.resume(returning: items)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
