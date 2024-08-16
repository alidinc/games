//
//  FeatureGameImage.swift
//  Speeltuin
//
//  Created by alidinc on 03/02/2024.
//

import SwiftUI

struct FeatureGameImage: View {
    
    var game: Game
    
    var body: some View {
        FeaturedGameImage
    }
    
    @ViewBuilder
    private var FeaturedGameImage: some View {
        if let name = game.name, let imageProps = gameImageProperties(for: name) {
            Image(imageProps.imageName)
                .resizable()
                .frame(width: imageProps.width, height: imageProps.height)
                .padding()
                .offset(y: imageProps.yOffset)
        }
    }
    
    struct FeatureGameImageProperties {
        var imageName: String
        var width: CGFloat
        var height: CGFloat
        var yOffset: CGFloat = 30 // Default offset for all images
    }
    
    func gameImageProperties(for name: String?) -> FeatureGameImageProperties? {
        guard let name = name?.lowercased() else { return nil }
        
        let mappings: [String: FeatureGameImageProperties] = [
            "mario": FeatureGameImageProperties(imageName: "mario", width: 50, height: 50),
            "zelda": FeatureGameImageProperties(imageName: "zelda", width: 50, height: 50),
            "assassin's creed": FeatureGameImageProperties(imageName: "assassinsCreed", width: 50, height: 50),
            "the witcher": FeatureGameImageProperties(imageName: "witcher", width: 120, height: 50),
            "red dead redemption": FeatureGameImageProperties(imageName: "reddead", width: 150, height: 50),
            "grand theft auto": FeatureGameImageProperties(imageName: "gta", width: 60, height: 50),
            "marvel": FeatureGameImageProperties(imageName: "marvel", width: 60, height: 50), // Assuming Marvel's condition is handled elsewhere
            "lego": FeatureGameImageProperties(imageName: "lego", width: 50, height: 50),
            "lord of the rings": FeatureGameImageProperties(imageName: "lord", width: 200, height: 50),
            "pokémon": FeatureGameImageProperties(imageName: "pokemon", width: 50, height: 50)
        ]
        
        for (key, value) in mappings {
            if name.contains(key) {
                return value
            }
        }
        
        return nil
    }
    
}
