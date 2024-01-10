//
//  DiscoverView.swift
//  JustGames
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftData
import SwiftUI

enum DataType: String, CaseIterable {
    case network
    case library
}

struct GamesView: View {
    
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white
    
    @Environment(Preferences.self) private var preferences
    @Environment(NetworkMonitor.self) private var network
    
    @State var vm: GamesViewModel
    
    @State private var showSelectionOptions = false
    @State private var selectedSegment: SegmentType = .genre
    @State private var multiPickerType: DataType = .network
    @State private var showSearchOverlay = false
    @State private var showGenresOverlay = false
    @State private var showPlatformsOverlay = false
    @State private var showLibraryOverlay = false
    @State private var searchTitle = "Search in network"
    
    @Query private var data: [SavedGame]
    
    var didRemoteChange = NotificationCenter
                            .default
                            .publisher(for: .NSPersistentStoreRemoteChange)
                            .receive(on: RunLoop.main)
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                ViewSwitcher
            }
            .background(.gray.opacity(0.15))
            .toolbarBackground(.hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .task(id: vm.fetchTaskToken) {
                await vm.fetchGames()
                vm.filterSegment(games: data)
            }
            .onChange(of: vm.searchQuery) { _, newValue in
                switch multiPickerType {
                case .network:
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
                case .library:
                    vm.filterSegment(games: data)
                    
                    DispatchQueue.main.async {
                        showSearchOverlay = vm.savedGames.isEmpty
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var ViewSwitcher: some View {
        ZStack {
            VStack(spacing: 10) {
                SearchTextField(searchQuery: $vm.searchQuery, prompt: $searchTitle)
                
                switch multiPickerType {
                case .network:
                    GamesCollectionView()
                case .library:
                    LibraryCollectionView(games: vm.savedGames)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
            .overlay {
                Overlay
            }
        }
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    private var  Overlay: some View {
        switch multiPickerType {
        case .network:
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
        case .library:
            if showLibraryOverlay {
                ContentUnavailableView(
                    "No content found for this library.",
                    systemImage: "gamecontroller.fill",
                    description: Text(
                        "Please add some games from the discover tab."
                    )
                )
            } else if showSearchOverlay && !vm.searchQuery.isEmpty {
                ContentUnavailableView.search(text: vm.searchQuery)
            } else if showGenresOverlay || showPlatformsOverlay {
                ContentUnavailableView(
                    "No content found for selected filters",
                    systemImage: "gamecontroller.fill",
                    description: Text(
                        "Please explore some new games."
                    )
                )
            }
        }
    }
    
    @ViewBuilder
    var Header: some View {
        VStack(spacing: 0) {
            HStack {
                MultiPicker
                Spacer()
                ViewTypeButton()
            }
            
            HStack(alignment: .center) {
                SelectedOptionsTitleView(reference: multiPickerType, selectedSegment: $selectedSegment) {
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
            SelectionsView(reference: $multiPickerType, selectedSegment: $selectedSegment)
                .presentationDetents([.medium, .large])
        })
    }
    
    
    @ViewBuilder
    private var ClearButton: some View {
        if vm.showDiscoverClearButton {
            Button(action: {
                vm.fetchTaskToken.platforms = [.database]
                vm.fetchTaskToken.genres = [.allGenres]
                
                switch multiPickerType {
                case .network:
                    Task {
                        await vm.refreshTask()
                    }
                case .library:
                    vm.filterSegment(games: data)
                    
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
    
    
    private var MultiPicker: some View {
        Menu {
            Text("Network")
            CategoryPicker
            
            Divider()
            
            Text("Library")
            LibraryPicker
            
        } label: {
            HStack(alignment: .center, spacing: 4) {
                HStack(spacing: 8) {
                    SFImage(name: vm.headerImageName, opacity: 0, radius: 0, padding: 0, color: appTint)
                    
                    Text(vm.headerTitle)
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
        .onReceive(didRemoteChange, perform: { _ in
            libraryFetch()
        })
        .task {
            libraryFetch()
        }
        .onChange(of: vm.selectedLibraryType, { oldValue, newValue in
            libraryFetch()
        })
        .onChange(of: vm.fetchTaskToken.platforms, { oldValue, newValue in
            withAnimation {
                if vm.fetchTaskToken.platforms.isEmpty {
                    vm.fetchTaskToken.platforms = [.database]
                } else {
                    vm.fetchTaskToken.platforms = newValue
                }
            }
            
            switch multiPickerType {
            case .network:
                Task {
                    await vm.refreshTask()
                }
                
            case .library:
                if vm.selectedPlatforms.isEmpty {
                    vm.selectedPlatforms = []
                } else {
                    vm.selectedPlatforms = newValue
                }
                
                vm.filterSegment(games: data)
                
                DispatchQueue.main.async {
                    showGenresOverlay = vm.savedGames.isEmpty
                }
            }
        })
        .onChange(of: vm.fetchTaskToken.genres, { oldValue, newValue in
            withAnimation {
                if vm.fetchTaskToken.genres.isEmpty {
                    vm.fetchTaskToken.genres = []
                } else {
                    vm.fetchTaskToken.genres = newValue
                }
            }
            
            switch multiPickerType {
            case .network:
                Task {
                    await vm.refreshTask()
                }
            case .library:
                if vm.selectedGenres.isEmpty {
                    vm.selectedGenres = [.allGenres]
                } else {
                    vm.selectedGenres = newValue
                }
                
                vm.filterSegment(games: data)
                
                DispatchQueue.main.async {
                    showGenresOverlay = vm.savedGames.isEmpty
                }
            }
        })
    }
    
    private func libraryFetch() {
        vm.filterSegment(games: data)
        showLibraryOverlay = vm.savedGames.isEmpty
    }
    
    private var CategoryPicker: some View {
        Menu {
            ForEach([Category.topRated,
                     Category.newReleases,
                     Category.upcoming], id: \.id) { category in
                Button {
                    vm.fetchTaskToken.category = category
                    vm.headerTitle = category.title
                    vm.headerImageName = category.systemImage
                    multiPickerType = .network
                    searchTitle = "Search in network"
                } label: {
                    Label(category.title, systemImage: category.systemImage).tag(category)
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
    
    
    private var LibraryPicker: some View {
        Menu {
            ForEach(LibraryType.allCases, id: \.id) { library in
                Button {
                    vm.selectedLibraryType = library
                    vm.headerTitle =  library.title
                    vm.headerImageName =  library.imageName
                    multiPickerType = .library
                    searchTitle = library.searchTitle
                } label: {
                    Label(library.title, systemImage: library.imageName).tag(library)
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 4) {
                HStack(spacing: 8) {
                    SFImage(name: vm.selectedLibraryType.imageName, opacity: 0, radius: 0, padding: 0, color: appTint)
                    
                    Text(vm.selectedLibraryType.title)
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

