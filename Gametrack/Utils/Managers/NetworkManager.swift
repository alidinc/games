//
//  NetworkManager.swift
//  Cards
//
//  Created by Ali Dinç on 04/12/2022.
//

import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    private let session = URLSession.shared
    private init() {}
    
    // MARK: - Private
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "GamesAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    private func generateAccessTokenURL() -> URL {
        var tokenURL = "https://id.twitch.tv/oauth2/token"
        tokenURL += "?client_id=\(Constants.IGDBAPI.ClientID)&client_secret=\(Constants.IGDBAPI.ClientScreet)&grant_type=client_credentials"
        return URL(string: tokenURL)!
    }
    
    private func getToken(from url: URL) async throws -> AccessToken {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, response) = try await self.session.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw self.generateError(description: "Bad Response")
        }
        
        switch response.statusCode {
        case (200...299), (400...499):
            return try JSONDecoder().decode(AccessToken.self, from: data)
        default:
            throw self.generateError(description: "A server error occured.")
        }
    }
    
    private func fetchREST<T: Codable>(with urlString: String) async throws -> [T] {
        guard let url = URL(string: urlString) else {
            throw self.generateError(description: "Invalid URL")
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await self.session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw self.generateError(description: "Bad Response")
        }
        
        switch response.statusCode {
        case (200...299), (400...499):
            return try JSONDecoder().decode([T].self, from: data)
        default:
            throw self.generateError(description: "A server error occured.")
        }
    }
    
    private func fetch<T: Codable>(with urlString: String, with apiCalypse: APICalypse) async throws -> [T] {
        var tokenResult = try await self.getToken(from: self.generateAccessTokenURL())
        guard tokenResult.expiryInSeconds > 10 else {
            tokenResult = try await self.getToken(from: self.generateAccessTokenURL())
            throw self.generateError(description: "Token expired")
        }
        
        guard let url = URL(string: urlString) else {
            throw self.generateError(description: "Invalid URL")
        }
        
        var requestHeader = URLRequest(url: url)
        requestHeader.httpBody = apiCalypse.buildQuery().data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = Constants.IGDBAPI.RequestType
        requestHeader.setValue(Constants.IGDBAPI.ClientID, forHTTPHeaderField: "Client-ID")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        requestHeader.setValue("Bearer \(tokenResult.token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await self.session.data(for: requestHeader)
        
        guard let response = response as? HTTPURLResponse else {
            throw self.generateError(description: "Bad Response")
        }
        
        switch response.statusCode {
        case (200...299), (400...499):
            self.showNetworkResponse(data: data)
            return try JSONDecoder().decode([T].self, from: data)
        default:
            throw self.generateError(description: "A server error occured.")
        }
    }

    // MARK: - Public
    
    func fetchDatabase() async throws -> [MultiQueryCountModel] {
        let apicalypse = APICalypse(type: .multi)
            .multiQuery(name: "games/count")
            .fields(fields: "*")
        return try await self.fetch(with: Constants.IGDBAPI.MultiQueryURL, with: apicalypse)
    }
    
    func fetchMulti(query: String? = nil,
                    with category: Category,
                    platforms: [PopularPlatform],
                    genres: [PopularGenre],
                    limit: Int, offset: Int = 0) async throws -> [MultiQueryModel] {
        
        let platformsString = platforms.map({ String($0.rawValue) }).joined(separator: ",")
        let platformQuery = platforms.contains(.database) ? "" : "platforms = (\(platformsString)) & "
        
        let genreString = genres.map { String($0.rawValue) }.joined(separator: ",")
        let genreQuery = genres.contains(.allGenres) ? "" : "genres = (\(genreString)) &"
        let apicalypse = APICalypse(type: .multi)
            .multiQuery(name: "games")
            .fields(fields: Constants.IGDBAPI.DetailFields)
            .search(searchQuery: query)
            .sort(field: category.sort, order: category.sortBy)
            .where(query: "\(platformQuery)\(genreQuery)\(category.where)")
            .limit(value: limit)
            .offset(value: offset)
        
        return try await self.fetch(with: Constants.IGDBAPI.MultiQueryURL, with: apicalypse)
    }
    
    func fetchDetailedGames(query: String? = nil,
                            with category: Category,
                            platforms: [PopularPlatform],
                            genres: [PopularGenre],
                            limit: Int = 0,
                            offset: Int = 0) async throws -> [Game] {
        
        let platformsString = platforms.map({ String($0.rawValue) }).joined(separator: ",")
        let platformQuery = platforms.contains(.database) ? "" : "platforms = (\(platformsString)) & "
        let genreString = genres.map { String($0.rawValue) }.joined(separator: ",")
        let genreQuery = genres.contains(.allGenres) ? "" : "genres = (\(genreString)) &"
        
        let apicalypse = APICalypse(type: .standard)
            .fields(fields: Constants.IGDBAPI.DetailFields)
            .search(searchQuery: query)
            .sort(field: category.sort, order: category.sortBy)
            .where(query: "\(platformQuery)\(genreQuery)\(category.where)")
            .limit(value: limit)
            .offset(value: offset)
        
        return try await self.fetch(with: Constants.IGDBAPI.BaseURL, with: apicalypse)
    }
    
    func fetchGames(ids: [Int]) async throws -> [Game] {
        let apicalypse = APICalypse(type: .standard)
            .fields(fields: Constants.IGDBAPI.DetailFields)
            .where(query: "id=(\(ids.compactMap({String($0)}).joined(separator: ",")))")
        
        return try await self.fetch(with: Constants.IGDBAPI.BaseURL, with: apicalypse)
    }
    
    func showNetworkResponse(data : Data){
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(jsonResult)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
}
