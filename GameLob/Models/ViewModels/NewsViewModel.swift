//
//  NewsViewModel.swift
//  JustGames
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
    
    var newsType: NewsType = .ign
    
    func fetchNews() async {
        guard let url = URL(string: newsType.urlString) else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .sink { _ in
        
            } receiveValue: { response in
                let parser = FeedParser(data: response)
                parser.parseAsync { result in
                    switch result {
                    case .success(let result):
                        if let items = result.rssFeed?.items {
                            DispatchQueue.main.async {
                                self.news = items
                            }
                        }
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            }
            .store(in: &bag)
    }
    
}
