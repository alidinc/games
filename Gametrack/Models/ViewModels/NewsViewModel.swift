//
//  NewsViewModel.swift
//  Gametrack
//
//  Created by Ali Dinç on 06/01/2024.
//

import SwiftUI
import Observation
import FeedKit

@Observable
class NewsViewModel {
    
    private var bag = Bag()
    
    var news: [RSSFeedItem] = []
    
    func fetchNews() async {
        guard let url = URL(string: "https://www.ign.com/rss/articles/feed?tags=games&start=50&count=50") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Fetched news")
                case .failure(_):
                    print("Failed to fetch news")
                }
            } receiveValue: { response in
                let parser = FeedParser(data: response)
                parser.parseAsync { result in
                    switch result {
                    case .success(let result):
                        if let items = result.rssFeed?.items {
                            DispatchQueue.main.async {
                                self.news = items
                                print("News: \(items.count)")
                            }
                        }
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
               
              //  print("News: \(response.items.count)")
            }
            .store(in: &bag)
    }
    
}
