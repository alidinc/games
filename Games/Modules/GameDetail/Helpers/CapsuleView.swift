//
//  CapsuleView.swift
//  Speeltuin
//
//  Created by alidinc on 18/01/2024.
//

import SwiftUI

struct CapsuleView: View {
    
    var title: String?
    @State var imageType: ImageType = .asset
    var imageName: String?
    
    var body: some View {
        HStack {
            if let imageName {
                switch imageType {
                case .sf:
                    Image(systemName: imageName)
                        .font(.system(size: 18))
                        .foregroundStyle(Color(uiColor: .label))
                    
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
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.sfButtonBackground, in: .capsule)
    }
}

enum ImageType {
    case sf
    case asset
}
