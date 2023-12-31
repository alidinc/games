//
//  SFImage.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftUI

struct SFImage: View {
    
    var name: String
    var opacity: CGFloat
    var radius: CGFloat
    var padding: CGFloat
    
    init(name: String, opacity: CGFloat = 0.5, radius: CGFloat = 8, padding: CGFloat = 10) {
        self.name = name
        self.opacity = opacity
        self.radius = radius
        self.padding = padding
    }
    
    var body: some View {
        Image(systemName: name)
            .imageScale(.large)
            .frame(width: 24, height: 24)
            .padding(padding)
            .background(Color.black.opacity(opacity), in: .rect(cornerRadius: radius))
    }
}
