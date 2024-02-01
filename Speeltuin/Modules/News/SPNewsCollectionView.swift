//
//  SPNewsCollectionView.swift
//  Speeltuin
//
//  Created by alidinc on 01/02/2024.
//

import SwiftUI
import SwiftData

struct SPNewsCollectionView: View {
    
    let dataManager: DataManager
    
    @AppStorage("viewType") var viewType: ViewType = .list
    @Environment(NewsViewModel.self) var vm: NewsViewModel
    @Environment(Admin.self) private var admin
    @State var selectedNews: SPNews?
    @State var updateList = false
    @Query(animation: .easeInOut) var savedNews: [SPNews]
    
    var headerDate: (String) -> Void
    let columns = Array(repeating: GridItem(), count: 3)
    
    var body: some View {
        ViewSwitcher
            .fullScreenCover(item: $selectedNews, content: { item in
                if let urlString = item.link, let url = URL(string: urlString) {
                    SFSafariView(url: url)
                        .navigationTitle(item.title)
                        .ignoresSafeArea()
                }
            })
            .overlay { NewsOverlayView() }
            .onChange(of: vm.newsType) { _, _ in
                updateList.toggle()
            }
    }
    
    var news: [SPNews] {
        switch admin.networkStatus {
        case .available:
            return savedNews
        case .unavailable:
            return []
        }
    }
    
    @ViewBuilder
    var ViewSwitcher: some View {
        switch viewType {
        case .list:
            SavedNewsListView
        case .grid:
            SavedNewsGridView
        }
    }
    
    var SavedNewsListView: some View {
        List {
            ForEach(vm.groupSavedNews(news: self.news), id: \.0) { section, items in
                ForEach(items, id: \.persistentModelID) { item in
                    Button {
                        selectedNews = item
                    } label: {
                        SPNewsListView(item: item, dataManager: dataManager)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
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
    
    var SavedNewsGridView: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.groupSavedNews(news: self.news), id: \.0) { section, items  in
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(items, id: \.persistentModelID) { item in
                            SPNewsGridView(item: item, dataManager: dataManager) {
                                self.selectedNews = item
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
