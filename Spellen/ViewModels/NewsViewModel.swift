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
    
    var ign: [RSSFeedItem] = []
    var nintendo: [RSSFeedItem] = []
    var xbox: [RSSFeedItem] = []
    
    var newsType: NewsType = .all
    
    func fetchNews() async {
        switch newsType {
        case .ign:
            fetch(type: .ign)
        case .nintendo:
            fetch(type: .nintendo)
        case .xbox:
            fetch(type: .xbox)
        case .all:
            print("All News")
        }
    }
    
    
    func fetch(type: NewsType) {
        guard let url = URL(string: type.urlString) else {
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
                                switch type {
                                case .ign:
                                    self.ign = items
                                case .nintendo:
                                    self.nintendo = items
                                case .xbox:
                                    self.xbox = items
                                case .all:
                                    self.news = self.ign + self.nintendo + self.xbox
                                }
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
