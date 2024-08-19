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

    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("viewType") var viewType: ViewType = .grid

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
                            .listRowInsets(.init(top: 5, leading: 12, bottom: 5, trailing: 12))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                case .grid:
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 3), spacing: 10) {
                            ForEach(vm.news) { item in
                                NewsGridItemView(item: item) {
                                    self.selectedItem = item
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
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
