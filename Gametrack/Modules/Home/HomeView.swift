//
//  GamesView.swift
//  A-games
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State private var vm = HomeViewModel()
    @AppStorage("collectionViewType") private var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Header
                ViewSwitcher
            }
            .background(.gray.opacity(0.15))
            .toolbarBackground(.hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .animation(.easeInOut, value: vm.fetchTaskToken.category)
            .overlay {
                LoadingView
            }
            .task(id: vm.fetchTaskToken) {
                await vm.fetchGames()
            }
            .onChange(of: vm.fetchTaskToken.category, { _, _ in
                Task {
                    await vm.refreshTask()
                }
            })
            .onChange(of: vm.searchQuery) { _, newValue in
                Task {
                    if !newValue.isEmpty {
                        try await Task.sleep(seconds: 0.5)
                        vm.fetchTaskToken.category = .database
                        await vm.refreshTask()
                    } else {
                        vm.fetchTaskToken.category = .topRated
                        await vm.refreshTask()
                        dismissKeyboard()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var LoadingView: some View {
        if vm.games.isEmpty {
            ZStack {
                ProgressView("Please wait, \nwhile we are getting ready! ☺️")
                    .font(.subheadline)
                    .tint(.white)
                    .multilineTextAlignment(.center)
                    .controlSize(.large)
            }
            .padding(.horizontal, 50)
            .hSpacing(.center)
            .offset(y: 50)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    var ViewSwitcher: some View {
        ZStack {
            VStack(spacing: 10) {
                SearchTextField(searchQuery: $vm.searchQuery)
                switch viewType {
                case .list:
                    GameListView(vm: vm)
                case .grid:
                    GameGridView(vm: vm)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    var Header: some View {
        VStack {
            HStack {
                CategoryButton
                Spacer()
                ViewTypeButton()
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            
            SelectionsHeaderView(vm: vm)
        }
    }
    
    
    private var CategoryButton: some View {
        Menu {
            Picker("Category", selection: $vm.fetchTaskToken.category) {
                ForEach([Category.topRated,
                         Category.newReleases,
                         Category.upcoming,
                         Category.upcomingThisMonth,
                         Category.upcomingThisWeek], id: \.id) {
                    Text($0.title).tag($0)
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 4) {
                Text(vm.fetchTaskToken.category.title)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.primary)
                    .shadow(radius: 10)
                   
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
            }
            .hSpacing(.leading)
        }
    }
}

