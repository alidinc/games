//
//  APICalypse.swift
//  IGDB-API-SWIFT
//
//  Created by Filip Husnjak on 2019-01-04.
//  Copyright © 2019 Filip Husnjak. All rights reserved.
//

import Foundation

enum APICalypseType {
    case standard
    case multi
}

public class APICalypse {
    private var search = ""
    private var fields = ""
    private var exclude = ""
    private var limit = ""
    private var offset = ""
    private var sort = ""
    private var _where = ""
    private var _queryName = ""
    
    var type: APICalypseType
    
    init(type: APICalypseType) {
        self.type = type
    }
    
    public func sort(field: String, order: Sort) -> APICalypse {
        self.sort = "s \(field) \(order.rawValue);"
        return self
    }
    
    public func fields(fields: String) -> APICalypse {
        self.fields = "f \(fields);"
        return self
    }
    
    public func exclude(fields: String) -> APICalypse {
        self.exclude = "x \(fields);"
        return self
    }
    
    public func limit(value: Int) -> APICalypse {
        self.limit = "l \(value);"
        return self
    }
    
    public func offset(value: Int) -> APICalypse {
        if value != 0 {
            self.offset = "o \(value);"
        }
        return self
    }
    
    public func search(searchQuery: String) -> APICalypse {
        self.search = "search \"\(searchQuery)\";"
        return self
    }
    
    public func `where`(query: String) -> APICalypse {
        if query.contains("where") || query.contains("w") {
            self._where = query
        } else {
            if query.contains(";") {
                self._where = "w \(query)"
            } else {
                self._where = "w \(query);"
            }
        }
        return self
    }
    
    public func multiQuery(name: String) -> APICalypse {
        if self.type == .multi {
            self._queryName = name
        }
        
        return self
    }
    
    public func buildQuery() -> String {
        var query = ""
        if !search.isEmpty {
            query = query + search
        }
        if !fields.isEmpty {
            query = query + fields
        }
        if !exclude.isEmpty {
            query = query + exclude
        }
        if !limit.isEmpty {
            query = query + limit
        }
        if !offset.isEmpty {
            query = query + offset
        }
        if !sort.isEmpty && search.isEmpty {
            query = query + sort
        }
        if !_where.isEmpty {
            query = query + _where
        }
        
        switch self.type {
        case .standard:
            return query
        case .multi:
            return "query \(_queryName) \"All games\" {\(query)};"
        }
    }
}

public enum Sort: String {
    case ASCENDING = "asc", DESCENDING = "desc"
}
