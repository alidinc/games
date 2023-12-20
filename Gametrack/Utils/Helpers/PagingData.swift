//
//  PagingData.swift
//  GoodGames
//
//  Created by Ali Dinç on 07/01/2023.
//

import Foundation

actor PagingData {
    
    private(set) var currentPage = 0
    private(set) var hasReachedEnd = false
    
    let itemsPerPage: Int
    let maxPageLimit: Int
    
    init(itemsPerPage: Int, maxPageLimit: Int) {
        self.itemsPerPage = itemsPerPage
        self.maxPageLimit = maxPageLimit
    }
    
    var nextPage: Int { currentPage + 1 }
    var shouldLoadNextPage: Bool {
        !hasReachedEnd && nextPage <= maxPageLimit
    }
    
    func loadNextPage<T>(dataFetchProvider: @escaping (Int) async throws -> [T]) async throws -> [T] {
        if Task.isCancelled { return [] }
        print("PAGING: Current Page \(currentPage), next page: \(nextPage)")
        
        guard shouldLoadNextPage else {
            print("PAGING: Stop loading next page. Has Reached end: \(hasReachedEnd), next page: \(nextPage), max page limit: \(maxPageLimit)")
            return []
        }
        
        let nextPage = self.nextPage
        let items = try await dataFetchProvider(nextPage)
        
        if Task.isCancelled || nextPage != self.nextPage { return [] }
        
        currentPage = nextPage
        hasReachedEnd = items.count < itemsPerPage
        
        print("PAGING: fetch \(items.count) items(s) successfully. Current Page: \(currentPage)")
        
        return items
    }
    
    func reset() {
        print("PAGING: RESET")
        currentPage = 0
        hasReachedEnd = false
    }
    
}
