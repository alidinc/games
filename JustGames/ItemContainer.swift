//
//  ItemContainer.swift
//  JustGames
//
//  Created by Ali Dinç on 12/01/2024.
//

import Foundation
import SwiftData

actor ItemContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([Library.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        
        if shouldCreateDefaults {
            shouldCreateDefaults = false
            
            let library = Library(id: Constants.allGamesLibraryID, title: "Allgames3043047560248756324328234932+.;lsd")
            container.mainContext.insert(library)
        }
       
        return container
    }
}

struct DefaultsJSON {
    
    static func decode<T: Codable>(from fileName: String, type: T.Type) -> T? {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        
        return result
    }
}
