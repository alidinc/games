//
//  NewsCollectionView.swift
//  Speeltuin
//
//  Created by alidinc on 01/02/2024.
//

import FeedKit
import SwiftUI

struct NewsCollectionView: View {
    
    let dataManager: DataManager
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("viewType") var viewType: ViewType = .list
    @Environment(NewsViewModel.self) private var vm: NewsViewModel
    @Environment(Admin.self) private var admin
    @State var selectedItem: RSSFeedItem?
    @State var updateList = false
    
    var headerDate: (String) -> Void
    let columns = Array(repeating: GridItem(), count: 3)
    
    var body: some View {
        ViewSwitcher
            .fullScreenCover(item: $selectedItem, content: { item in
                if let urlString = item.link, let url = URL(string: urlString) {
                    SFSafariView(url: url)
                        .navigationTitle(item.title ?? "")
                        .ignoresSafeArea()
                }
            })
            .refreshable { await vm.fetchNews() }
            .overlay { NewsOverlayView() }
            .onChange(of: vm.newsType) { _, _ in
                updateList.toggle()
            }
    }
    
    var news: [RSSFeedItem] {
        switch admin.networkStatus {
        case .available:
            switch vm.newsType {
            case .all:
                return vm.allNews
            case .nintendo:
                return vm.nintendo
            case .xbox:
                return vm.xbox
            case .ign:
                return vm.ign
            }
        case .unavailable:
            return []
        }
    }
    
    @ViewBuilder
    var ViewSwitcher: some View {
        switch viewType {
        case .list:
            NewsListView
        case .grid:
            NewsGridView
        }
    }
    
    var NewsListView: some View {
        List {
            ForEach(vm.groupNews(items: self.news), id: \.0) { section, items in
                ForEach(items, id: \.title) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        NewsListItemView(item: item, dataManager: dataManager)
                    }
                }
                .listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .onChange(of: section, initial: true) { oldValue, newValue in
                    headerDate(newValue.asString(style: .medium))
                }
            }
        }
        .id(updateList)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .listStyle(.plain)
    }
    
    var NewsGridView: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.groupNews(items: self.news), id: \.0) { section, items in
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(items, id: \.link) { item in
                            NewsGridItemView(item: item, dataManager: dataManager) {
                                self.selectedItem = item
                            }
                        }
                        .onChange(of: section, initial: true) { oldValue, newValue in
                            headerDate(newValue.asString(style: .medium))
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .id(updateList)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .listStyle(.plain)
    }
}

