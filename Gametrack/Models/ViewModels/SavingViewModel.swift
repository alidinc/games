//
//  SavingViewModel.swift
//  Gametrack
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI
import Observation
import SwiftData

@Observable
class SavingViewModel {
    
    private var bag = Bag()
    
    var imageData: Data?
    
    func getImageData(from game: Game) {
        if let cover = game.cover,
           let urlString = cover.url,
           let url = URL(string: "https:\(urlString.replacingOccurrences(of: "t_thumb", with: "t_1080p"))") {
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Downloaded")
                    case .failure(_):
                        print("Failed to download")
                    }
                } receiveValue: { [weak self] data in
                    if let image = UIImage(data: data)?.jpegData(compressionQuality: 0.1) {
                        self?.imageData = data
                    }
                }
                .store(in: &bag)
        }
    }
}
