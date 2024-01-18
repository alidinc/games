//
//  CapsuleView.swift
//  Spellen
//
//  Created by alidinc on 18/01/2024.
//

import SwiftUI

struct CapsuleView: View {
    
    var title: String
    var imageName: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 16, height: 16)
            
            Text(title)
                .font(.caption)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(Color.randomDarkColor.gradient, in: .capsule)
    }
}
