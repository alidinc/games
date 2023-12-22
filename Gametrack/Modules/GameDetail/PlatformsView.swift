//
//  PlatformsView.swift
//  Gametrack
//
//  Created by Ali Dinç on 22/12/2023.
//

import SwiftUI


struct PlatformsView: View {
    
    @State var platforms: [Platform]
    
    var body: some View {
        if self.platforms.count > 8 {
            Text(self.platforms.compactMap({$0.abbreviation}).joined(separator: ", "))
                .lineLimit(3)
                .font(.caption2)
        } else {
            LogoView
        }
    }
    
    @ViewBuilder
    private var LogoView: some View {
        HStack(spacing: 10) {
            ForEach(self.platforms, id: \.self) { platform in
                if let popularPlatform = platform.platform {
                    Image(popularPlatform.assetName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 24)
                        
                } else {
                    if let abbreviation = platform.abbreviation {
                        AbbreviationsView(with: abbreviation)
                    }
                }
            }
        }
    }
    
    
    @ViewBuilder
    func AbbreviationsView(with abb: String) -> some View {
        Text(abb)
            .lineLimit(1)
            .padding(4)
            .font(.caption2)
            .background(Color.gray.opacity(0.25))
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}
