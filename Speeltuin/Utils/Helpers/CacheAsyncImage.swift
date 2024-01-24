//
//  CacheAsyncImage.swift
//  Speeltuin
//
//  Created by Ali Dinç on 29/12/2023.
//

import SwiftUI

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
        if let cached = ImageCache[url.absoluteString] {
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
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            // Wrap UIImage in a class to store in NSCache
            ImageCache[url.absoluteString] = image
        }
        return content(phase)
    }
}

fileprivate class ImageCache {
    static let sharedCache = NSCache<NSString, ImageWrapper>()
    
    static subscript(key: String) -> Image? {
        get {
            // Access the cache safely
            return ImageCache.sharedCache.object(forKey: key as NSString)?.image
        }
        set {
            // Access the cache safely
            if let newValue = newValue {
                ImageCache.sharedCache.setObject(ImageWrapper(image: newValue), forKey: key as NSString)
            } else {
                ImageCache.sharedCache.removeObject(forKey: key as NSString)
            }
        }
    }
}

class ImageWrapper {
    let image: Image
    
    init(image: Image) {
        self.image = image
    }
}
