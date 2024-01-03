//
//  AsyncImageView.swift
//  A-games
//
//  Created by Ali Dinç on 17/12/2023.
//

import Foundation
import SwiftUI

enum AsyncImageType: String, CaseIterable {

    case list
    case grid
    case card
    case mediaView
    case detail
    
    var width: CGFloat {
        switch self {
        case .list:
            return 120
        case .grid:
            return UIScreen.main.bounds.size.width / 3.3
        case .card:
            return UIScreen.main.bounds.size.width
        case .mediaView:
            return UIScreen.main.bounds.size.width - 20
        case .detail:
            return UIScreen.main.bounds.size.width
        }
    }
    
    var height: CGFloat {
        switch self {
        case .list:
            return 160
        case .grid:
            return self.width * 1.32
        case .card:
            return UIScreen.main.bounds.size.height * 0.5
        case .mediaView:
            return self.width * 0.75
        case .detail:
            return UIScreen.main.bounds.size.height * 0.6
        }
    }
    
    var downloadQuality: String {
        switch self {
        case .list, .grid:
            return "cover_big"
        default:
            return "1080p"
        }
    }
    
    func urlString(string: String) -> URL? {
        switch self {
        default:
            return URL(string: "https:\(string.replacingOccurrences(of: "t_thumb", with: "t_\(self.downloadQuality)"))")
        }
    }
}

struct AsyncImageView: View {
    
    @State var type: AsyncImageType
    @State var urlString: String?
    @State var radius: CGFloat = 5
    
    init(with urlString: String, type: AsyncImageType, radius: CGFloat = 5) {
        self.urlString = urlString
        self.type = type
        self.radius = radius
    }
    
    var body: some View {
        if let urlString = self.urlString {
            if let imageURL = self.type.urlString(string: urlString) {
                CacheAsyncImage(url: imageURL, transaction: .init(animation: .default)) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.black.opacity(0.25)
                            ProgressView()
                        }
                        .frame(width: self.type.width, height: self.type.height)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .shadow(color: .white.opacity(0.7), radius: 10)
                            .frame(width: self.type.width, height: self.type.height)
                            .clipShape(.rect(cornerRadius: self.radius))
                        
                    case .failure:
                        ImagePlaceholder(type: self.type, radius: self.radius)
                    @unknown default:
                        fatalError()
                    }
                }
            }
        } else {
            ImagePlaceholder(type: self.type)
        }
    }
}

struct ImagePlaceholder: View {
    
    var type: AsyncImageType
    
    @State var radius: CGFloat = 5
    
    var body: some View {
        Image(systemName: "photo")
            .font(.largeTitle)
            .hSpacing(.center)
            .vSpacing(.center)
            .background(Color.black.opacity(0.25), in: .rect(cornerRadius: 8))
            .frame(width: type.width, height: type.height)
    }
}
