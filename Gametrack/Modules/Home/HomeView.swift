//
//  GamesView.swift
//  A-games
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State private var vm = HomeViewModel()
    @FocusState private var focused: Bool
    @AppStorage("collectionViewType") private var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .purple
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
                        withAnimation {
                            vm.fetchTaskToken.category = .database
                        }
                        await vm.refreshTask()
                    } else {
                        withAnimation {
                            vm.fetchTaskToken.category = .topRated
                        }
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
            switch viewType {
            case .list:
                VStack(spacing: 0) {
                    SearchButton
                    GameListView(vm: vm)
                }.padding(.top, 10)
            case .grid:
                VStack(spacing: 0) {
                    SearchButton
                    GameGridView(vm: vm)
                }.padding(.top, 10)
            case .card:
                VStack(spacing: 20) {
                    SearchButton
                    GameCardsView(vm: vm)
                }.padding(.top, 10)
            }
        }
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    var Header: some View {
        VStack {
            HStack {
                CategoryButton
                Spacer()
                ViewTypeButton
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            
            SelectionsHeaderView(vm: $vm)
        }
    }
    
    
    private var SearchButton: some View {
        HStack(spacing: 0) {
            TextField("", text: $vm.searchQuery)
                .frame(height: 24, alignment: .leading)
                .padding(10)
                .background(.ultraThinMaterial, in: .rect(topLeadingRadius: 8, bottomLeadingRadius: 8))
                .focused($focused)
                .autocorrectionDisabled()
                .overlay {
                    if !vm.searchQuery.isEmpty {
                        HStack {
                            Spacer()
                            Button {
                                vm.searchQuery = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                            }
                            .foregroundColor(.secondary)
                        }
                        .padding(.trailing, 6)
                    }
                }
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(appTint)
                .aspectRatio(contentMode: .fit)
                .padding(10)
                .background(
                    .ultraThinMaterial,
                    in: .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 8,
                        topTrailingRadius: 8
                    )
                )
        }
        .padding(.horizontal)
    }
    
    private var ViewTypeButton: some View {
        Menu {
            Section("View type") {
                Button {
                    DispatchQueue.main.async {
                        viewType = .list
                    }
                } label: {
                    Image(systemName: "rectangle.grid.1x2.fill")
                    Text("List")
                }
                
                Button {
                    DispatchQueue.main.async {
                        viewType = .grid
                    }
                } label: {
                    Image(systemName: "rectangle.grid.3x2.fill")
                    Text("Grid")
                }
                
                Button {
                    DispatchQueue.main.async {
                        viewType = .card
                    }
                } label: {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                    Text("Card")
                }
            }
            
        } label: {
            Image(systemName: viewType.imageName)
                .resizable()
                .frame(width: 24, height: 24)
                .aspectRatio(contentMode: .fit)
                .padding(10)
                .background(Color.black.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        } primaryAction: {
            withAnimation(.snappy) {
                if viewType == .list {
                    viewType = .grid
                } else if viewType == .grid {
                    viewType = .card
                } else if viewType == .card {
                    viewType = .list
                }
            }
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

