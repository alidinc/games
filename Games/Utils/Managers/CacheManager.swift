//
//  CacheManager.swift
//  Speeltuin
//
//  Created by Ali Dinç on 16/03/2023.
//

import Foundation


final class CacheManager {
    
    private init() { }
    static let shared = CacheManager()
    
    private var saveLocationURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    func removeFromDisk(file: String) {
        try? FileManager.default.removeItem(at: self.saveLocationURL)
    }
    
    func loadFromFile<T: Codable>(file: String) -> [T]? {
        do {
            // Read the data from the file URL
            let fileName = self.saveLocationURL.appendingPathComponent(file)
            let data = try Data(contentsOf: fileName)
            
            // Decode the data into an array of DataModel objects
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([T].self, from: data)
            
            return decodedData
        } catch {
            // Return nil if the file doesn't exist or can't be read
            return nil
        }
    }
    
    func saveCachedData<T: Codable>(_ data: [T], to file: String) {
        do {
            // Encode the data as JSON
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            
            // Write the data to the file URL
            let fileName = self.saveLocationURL.appendingPathComponent(file)
            try encodedData.write(to: fileName)
        } catch {
            // Handle the error if the data can't be written to the file
        }
    }
}
