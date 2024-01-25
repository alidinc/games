//
//  NewsView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 06/01/2024.
//

import FeedKit
import SwiftUI
import SafariServices

struct NewsView: View {
    
    @State var vm = NewsViewModel()
    @State var presentLink = false
    @State var selectedItem: RSSFeedItem?
    
    @State var updateList = false
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .white
    @AppStorage("viewType") var viewType: ViewType = .list
    
    @Environment(Admin.self) private var admin: Admin
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView
                ViewSwitcher
                    
            }
            .background(.gray.opacity(0.15))
            .task(id: vm.newsType, priority: .background, {
                await vm.fetchNews()
            })
            .sheet(item: $selectedItem, content: { item in
                if let urlString = item.link, let url = URL(string: urlString) {
                    SFSafariView(url: url)
                        .background(.gray.opacity(0.15))
                        .navigationTitle(item.title ?? "")
                        .ignoresSafeArea()
                }
            })
            .onChange(of: vm.newsType) { oldValue, newValue in
                updateList.toggle()
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
            }
        }
    }
    
    var items: [RSSFeedItem] {
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
    var LoadingView: some View {
        switch admin.networkStatus {
        case .available:
            if vm.allNews.isEmpty {
                ZStack {
                    ProgressView("Please wait, \nwhile we are getting ready! ☺️")
                        .font(.subheadline)
                        .tint(.white)
                        .multilineTextAlignment(.center)
                        .controlSize(.large)
                }
                .hSpacing(.center)
                .padding(.horizontal, 50)
                .ignoresSafeArea()
            }
        case .unavailable:
            ContentUnavailableView(
                "No network available",
                systemImage: "exclamationmark.triangle.fill",
                description: Text(
                    "We are unable to display any content as your iPhone is not currently connected to the internet."
                )
            )
        }
    }
    
    var HeaderView: some View {
        HStack {
            Menu {
                Picker("", selection: $vm.newsType) {
                    ForEach(NewsType.allCases, id: \.id) { news in
                        Text(news.title).tag(news)
                    }
                }
            } label: {
                PickerHeaderView(title: vm.newsType.title, imageName: "newspaper.fill")
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Today")
                    .font(.headline.bold())
                    .foregroundStyle(.primary)
                
                Text(Date.now.asString(style: .medium))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(appTint)
        .padding(.horizontal)
        .padding(.top)
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
    
    var NewsGridView: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.groupedAndSortedItems(items: self.items), id: \.0) { section, items in
                    Section {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5) {
                            ForEach(items, id: \.link) { item in
                                NewsGridItemView(onSelect: {
                                    self.selectedItem = item
                                }, item: item)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    } header: {
                        Text(section)
                            .font(.headline.bold())
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        .id(updateList)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .padding(.bottom, 5)
        .overlay {
            LoadingView
        }
    }
    
    var NewsListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.groupedAndSortedItems(items: self.items), id: \.0) { section, items in
                    Section {
                        ForEach(items, id: \.link) { item in
                            Button {
                                selectedItem = item
                            } label: {
                                NewsListItemView(item: item)
                            }
                        }
                    } header: {
                        Text(section)
                            .font(.headline.bold())
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                    }
                }
            }
        }
        .id(updateList)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .padding(.bottom, 5)
        .padding(.horizontal, 10)
        .overlay {
            LoadingView
        }
    }
}

extension RSSFeedItem: Identifiable {}
