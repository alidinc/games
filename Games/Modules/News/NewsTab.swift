//
//  NewsView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 06/01/2024.
//

import FeedKit
import SwiftUI
import SwiftData
import SafariServices

struct NewsTab: View {

    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("viewType") var viewType: ViewType = .list

    @Environment(Admin.self) private var admin
    @State var selectedItem: RSSFeedItem?
    @Bindable var vm: NewsViewModel

    @State private var id = UUID()

    var body: some View {
        NavigationStack {
            Group {
                switch viewType {
                case .list:
                    List {
                        ForEach(vm.news) { item in
                            Button {
                                selectedItem = item
                            } label: {
                                NewsListItemView(item: item)
                            }
                            .listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                case .grid:
                    ScrollView {
                        ForEach(vm.news) { item in
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 5)  {
                                NewsGridItemView(item: item) {
                                    self.selectedItem = item
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                }
            }
            .id(id)
            .fullScreenCover(item: $selectedItem, content: { item in
                if let urlString = item.link, let url = URL(string: urlString) {
                    SFSafariView(url: url)
                        .navigationTitle(item.title ?? "")
                        .ignoresSafeArea()
                }
            })
            .onChange(of: vm.newsType) { _,_ in
                self.id = UUID()
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
            }
        }
    }
}

extension RSSFeedItem: Identifiable {}
