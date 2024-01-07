//
//  DiscoverView.swift
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftUI

struct DiscoverView: View {
    
    @State var vm: DiscoverViewModel
    
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white
    
    @Environment(Preferences.self) private var preferences
    @Environment(NetworkMonitor.self) private var network
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSelectionOptions = false
    @State private var selectedSegment: SegmentType = .genre
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                ViewSwitcher
            }
            .if(preferences.networkStatus == .network, transform: { view in
                view
                    .refreshable {
                        Task {
                            await vm.refreshTask()
                        }
                    }
                
            })
            .background(.gray.opacity(0.15))
            .toolbarBackground(.hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .navigationBar)
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
            .hSpacing(.center)
            .padding(.horizontal, 50)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    var ViewSwitcher: some View {
        ZStack {
            VStack(spacing: 10) {
                SearchTextField(searchQuery: $vm.searchQuery)
                DiscoverCollectionView(viewType: $viewType)
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
            .overlay {
                Overlay
            }
        }
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    private var Overlay: some View {
        if preferences.networkStatus == .local {
            ContentUnavailableView(
                "No network available",
                systemImage: "exclamationmark.triangle.fill",
                description: Text(
                    "We are unable to display any content as your iPhone is not currently connected to the internet."
                )
            )
            .task {
                await vm.refreshTask()
            }
        } else {
            LoadingView
        }
    }
    
    @ViewBuilder
    var Header: some View {
        VStack(spacing: 0) {
            HStack {
                CategoryPicker
                Spacer()
                ViewTypeButton()
            }
            
            HStack(alignment: .center) {
                SelectedOptionsTitleView(reference: .network, selectedSegment: $selectedSegment) {
                    withAnimation {
                        showSelectionOptions = true
                    }
                }
                
                ClearButton
            }
            .frame(maxHeight: 40)
        }
        .padding(.horizontal)
        .padding(.top)
        .sheet(isPresented: $showSelectionOptions, content: {
            SelectionsView(reference: .network, selectedSegment: $selectedSegment)
                .presentationDetents([.medium, .large])
        })
    }
    
    @ViewBuilder
    private var ClearButton: some View {
        if (!vm.fetchTaskToken.genres.isEmpty && !vm.fetchTaskToken.genres.contains(.allGenres))  || (!vm.fetchTaskToken.platforms.isEmpty && !vm.fetchTaskToken.platforms.contains(.database)) {
            Button(action: {
                Task {
                    vm.fetchTaskToken.platforms = [.database]
                    vm.fetchTaskToken.genres = [.allGenres]
                    await vm.refreshTask()
                }
            }, label: {
                Text("Clear")
                    .font(.caption)
                    .padding(6)
                    .background(.secondary, in: .capsule)
                    .padding(6)
            })
        }
    }
    
    
    private var CategoryPicker: some View {
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
                HStack(spacing: 8) {
                    SFImage(name: vm.fetchTaskToken.category.systemImage, opacity: 0, radius: 0, padding: 0, color: appTint)
                    
                    Text(vm.fetchTaskToken.category.title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.primary)
                        .shadow(radius: 10)
                }
                
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
            }
            .hSpacing(.leading)
        }
    }
}

