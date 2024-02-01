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
    
    let dataManager: DataManager
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("viewType") var viewType: ViewType = .list
    @State var vm: NewsViewModel
    
    @State var headerDate = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                ViewSwitcher
            }
            .padding(.bottom, 1)
            .background(.gray.opacity(0.15))
            .onChange(of: vm.newsType) { oldValue, newValue in
                vm.dataType = .network
                vm.headerTitle = newValue.title
                
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
            }
        }
    }
    
    var Header: some View {
        HStack(alignment: .bottom) {
            NewsSourcePicker
            Spacer()
            Text(headerDate)
                .font(.subheadline.bold())
                .frame(height: 44)
                .offset(y: 10)
        }
        .foregroundStyle(appTint)
        .padding(.horizontal)
        .padding(.top)
    }
    
    @ViewBuilder
    var ViewSwitcher: some View {
        switch vm.dataType {
        case .network:
            NewsCollectionView(dataManager: dataManager) { headerDate in
                self.headerDate = headerDate
            }
        case .library:
            SPNewsCollectionView(dataManager: dataManager) { headerDate in
                self.headerDate = headerDate
            }
        }
    }
    
    var NewsSourcePicker: some View {
        Menu {
            ForEach(NewsType.allCases, id: \.id) { news in
                Button {
                    vm.dataType = .network
                    vm.newsType = news
                    vm.headerTitle = news.title
                } label: {
                    Text(news.title)
                }
            }
            
            Divider()
            
            Button {
                vm.dataType = .library
                vm.headerTitle = "Saved news"
            } label: {
                Label("Saved news", systemImage: "bookmark")
            }

        } label: {
            PickerHeaderView(title: vm.headerTitle)
        }
    }
}

extension RSSFeedItem: Identifiable {}
