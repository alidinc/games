//
//  NewsView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 06/01/2024.
//

import FeedKit
import SwiftUI
import SafariServices

struct NewsTab: View {
    
    @State var presentLink = false
    @State var selectedItem: RSSFeedItem?
    @State var updateList = false
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("viewType") var viewType: ViewType = .list
    
    @Environment(Admin.self) private var admin: Admin
    @State var vm: NewsViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                ViewSwitcher
            }
            .padding(.bottom, 1)
            .background(.gray.opacity(0.15))
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
    var Overlay: some View {
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
    
    var Header: some View {
        HStack {
            NewsSourcePicker
            Spacer()
            TodayView
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
                .overlay { Overlay }
        case .grid:
            NewsGridView
                .overlay { Overlay }
        }
    }
    
    var NewsSourcePicker: some View {
        Menu {
            Picker("", selection: $vm.newsType) {
                ForEach(NewsType.allCases, id: \.id) { news in
                    Text(news.title).tag(news)
                }
            }
        } label: {
            PickerHeaderView(title: vm.newsType.title, imageName: "newspaper.fill")
        }
    }
    
    var TodayView: some View {
        VStack(alignment: .trailing) {
            Text("Today")
                .font(.headline.bold())
                .foregroundStyle(.primary)
            
            Text(Date.now.asString(style: .medium))
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
                            .padding(.leading, 10)
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
    }
    
    var NewsListView: some View {
        List {
            ForEach(vm.groupedAndSortedItems(items: self.items), id: \.0) { section, items in
                VStack(alignment: .leading) {
                    Text(section)
                        .font(.headline.bold())
                        .foregroundStyle(.gray)
                        .padding(.leading, 10)
                        .hSpacing(.leading)
                    
                    ForEach(items, id: \.link) { item in
                        Button {
                            selectedItem = item
                        } label: {
                            NewsListItemView(item: item)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .id(updateList)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .listStyle(.plain)
    }
}

extension RSSFeedItem: Identifiable {}
