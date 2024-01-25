//
//  CapsuleView.swift
//  Speeltuin
//
//  Created by alidinc on 18/01/2024.
//

import SwiftUI

struct CapsuleView: View {
    
    var title: String?
    var imageType: ImageType = .asset
    var imageName: String?
    
    var body: some View {
        VStack {
            if let imageName {
                switch imageType {
                case .sf:
                    Image(systemName: imageName)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                    
                case .asset:
                    Image(imageName)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            
            if let title {
                Text(title)
                    .font(.caption2)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(6)
    
    }
}

enum ImageType {
    case sf
    case asset
}
