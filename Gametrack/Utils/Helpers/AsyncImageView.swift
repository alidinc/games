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
    case horizontal
    case mediaView
    case infinity
    case detail
    
    var placeholderSize: CGFloat {
        switch self {
        default:
            return 75
        }
    }
    
    var width: CGFloat {
        switch self {
        case .list:
            return 120
        case .horizontal:
            return 150
        case .grid:
            return UIScreen.main.bounds.size.width / 3.3
        case .card:
            return UIScreen.main.bounds.size.width
        case .mediaView:
            return UIScreen.main.bounds.size.width - 20
        case .infinity:
            return .infinity
        case .detail:
            return UIScreen.main.bounds.size.width
        }
    }
    
    var height: CGFloat {
        switch self {
        case .list:
            return 160
        case .horizontal:
            return 210
        case .grid:
            return self.width * 1.32
        case .card:
            return UIScreen.main.bounds.size.height * 0.5
        case .mediaView:
            return self.width * 0.75
        case .infinity:
            return .infinity
        case .detail:
            return UIScreen.main.bounds.size.height * 0.6
        }
    }
    
    var placeholderImageName: String {
        switch self {
        default:
            return "photo"
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
    
    var ratio: ContentMode {
        switch self {
        case .mediaView:
            return .fit
        default:
            return .fill
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
                        if self.type == .mediaView {
                            ProgressView()
                        } else {
                            ZStack {
                                Color.black.opacity(0.25).cornerRadius(self.radius)
                                ProgressView()
                            }
                            .if(self.type == .infinity) { view in
                                view
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .if(self.type != .infinity) { view in
                                view
                                    .frame(width: self.type.width, height: self.type.height)
                            }
                        }
                    case .success(let image):
                        if self.type == .mediaView {
                            image
                                .resizable()
                                .aspectRatio(contentMode: self.type.ratio)
                                .shadow(color: .primary.opacity(0.5), radius: 10)
                                .clipShape(.rect(cornerRadius: self.radius))
                            
                        } else {
                            image
                                .resizable()
                                .aspectRatio(contentMode: self.type.ratio)
                                .shadow(color: .white.opacity(0.5), radius: 10)
                                .if(self.type == .infinity) { view in
                                    view
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                .if(self.type != .infinity) { view in
                                    view
                                        .frame(width: self.type.width, 
                                               height: self.type.height)
                                }
                                .if(self.type != .detail) { view in
                                      view.clipShape(RoundedRectangle(cornerRadius: self.radius))
                                }
                        }

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
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: self.type.placeholderImageName)
                    .resizable()
                    .scaledToFit()
                    .if(self.type == .infinity) { view in
                        view
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .if(self.type != .infinity) { view in
                        view
                            .frame(width: self.type.placeholderSize, height: self.type.placeholderSize)
                    }
                    .foregroundColor(Color.white.opacity(0.25))
                Spacer()
            }
            Spacer()
        }
        .background(Color.black.opacity(0.25))
        .if(self.type == .infinity) { view in
            view
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .if(self.type != .infinity) { view in
            view
                .frame(width: self.type.width, height: self.type.height)
        }
        .cornerRadius(self.radius)
    }
}

struct CacheAsyncImage<Content>: View where Content: View {
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 0.1,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ){
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ){ phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View{
        if case .success (let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}
fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image?{
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
