//
//  CapsuleView.swift
//  Speeltuin
//
//  Created by alidinc on 18/01/2024.
//

import SwiftUI

struct CapsuleView: View {
    
    var title: String?
    var subtitle: String?
    var imageType: ImageType = .asset
    var imageName: String?

    init(title: String? = nil, subtitle: String? = nil, imageType: ImageType, imageName: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.imageType = imageType
        self.imageName = imageName
    }

    var body: some View {
        HStack(alignment: .center) {
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
            
            VStack(alignment: .leading) {
                if let title {
                    Text(title)
                        .font(.footnote)
                }

                if let subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        
    }
}

enum ImageType {
    case sf
    case asset
}
