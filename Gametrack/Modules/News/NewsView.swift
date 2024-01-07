//
//  NewsView.swift
//  Gametrack
//
//  Created by Ali Dinç on 06/01/2024.
//

import FeedKit
import SwiftUI
import SafariServices

struct NewsView: View {
    
    @State var vm = NewsViewModel()
    @State var presentLink = false
    
    @AppStorage("appTint") var appTint: Color = .white
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView
                GameNewsListView
            }
            .background(.gray.opacity(0.15))
            .task {
                await vm.fetchNews()
            }
        }
    }
    
    var HeaderView: some View {
        HStack(alignment: .center, spacing: 4) {
            HStack(spacing: 8) {
                SFImage(name: "newspaper.fill", opacity: 0, radius: 0, padding: 0, color: appTint)
                
                Text("News")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.primary)
                    .shadow(radius: 10)
            }
        }
        .hSpacing(.leading)
        .padding(.horizontal)
        .foregroundStyle(appTint)
    }
    
    var GameNewsListView: some View {
        List(vm.news) { news in
            NavigationLink {
                if let urlString = news.link, let url = URL(string: urlString) {
                    SFSafariView(url: url)
                        .navigationTitle(news.title ?? "")
                }
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        if let title = news.title {
                            Text(title)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        
                        if let description = news.description {
                            Text(description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let date = news.pubDate {
                            Text(date.asString(style: .medium))
                                .foregroundStyle(.gray)
                                .font(.caption2)
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NewsView()
}

struct SFSafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        return SFSafariViewController(url: url, configuration: config)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariView>) {
        // No need to do anything here
    }
}

extension RSSFeedItem: Identifiable {
    
}

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    // 1
    let url: URL
    
    
    // 2
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        prefs.preferredContentMode = .mobile
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        return WKWebView(frame: .zero, configuration: config)
    }
    
    // 3
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
