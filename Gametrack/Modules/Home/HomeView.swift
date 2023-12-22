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
            .overlay {
                LoadingView
            }
            .task(id: vm.fetchTaskToken) {
                await vm.fetchGames()
            }
            .onChange(of: vm.fetchTaskToken.category, { oldValue, newValue in
                Task {
                    await vm.refreshTask()
                }
            })
        }
    }
    
    @ViewBuilder
    var LoadingView: some View {
        if vm.viewNotReady {
            ZStack {
                ProgressView("Please wait, \nwhile we are getting ready! ☺️")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .controlSize(.large)
            }
            .padding(.horizontal, 50)
            .hSpacing(.center)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    var ViewSwitcher: some View {
        ZStack {
            switch viewType {
            case .list:
                GameListView(vm: vm)
            case .grid:
                GameGridView(vm: vm)
            case .card:
                GameCardsView(vm: vm)
            }
        }
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
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
    
   
    
    private var ViewTypeButton: some View {
        Menu {
            Section("View type") {
                Button {
                    viewType = .list
                } label: {
                    Image(systemName: "rectangle.grid.1x2.fill")
                    Text("List")
                }
                
                Button {
                    viewType = .grid
                } label: {
                    Image(systemName: "rectangle.grid.3x2.fill")
                    Text("Grid")
                }
                
                Button {
                    viewType = .card
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
        }
    }
    
    
    
    
}
