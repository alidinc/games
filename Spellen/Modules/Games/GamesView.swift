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

enum FilterType {
    case search
    case library
    case genre
    case platform
}

struct GamesView: View {
    
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white
    
    @Environment(Preferences.self) private var preferences
    @Environment(NetworkMonitor.self) private var network
    
    @State var vm: GamesViewModel
    
    @State var gameToAddForNewLibrary: Game?
    
    @State private var filterType: FilterType = .library
    @State private var showLibraries = false
    @State private var showAddLibrary = false
    @State private var showSelectionOptions = false
    @State private var selectedSegment: SegmentType = .genre
    @State private var dataType: DataType = .network
    @State private var selectedLibrary: Library?
    
    @Query(animation: .easeInOut) private var savedGames: [SavedGame]
    @Query(animation: .easeInOut) private var savedLibraries: [Library]
    
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
            }
            .sheet(isPresented: $showLibraries, content: {
                LibraryView()
                    .presentationDetents([.medium])
            })
            .sheet(isPresented: $showAddLibrary, content: {
                AddLibraryView(game: gameToAddForNewLibrary)
                    .presentationDetents([.fraction(0.7)])
            })
            .onReceive(NotificationCenter.default.publisher(for: .newLibraryButtonTapped), perform: { notification in
                showAddLibrary = true
                if let game = notification.object as? Game {
                    gameToAddForNewLibrary = game
                }
            })
            .onReceive(didRemoteChange, perform: { _ in
                vm.filterSegment(games: savedGames, library: selectedLibrary,  libraries: savedLibraries)
            })
            .onChange(of: vm.searchQuery) { _, newValue in
                filterType = .search
                
                switch dataType {
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
                    vm.filterSegment(games: savedGames, library: selectedLibrary, libraries: savedLibraries)
                }
            }
        }
    }
    
    private var ViewSwitcher: some View {
        ZStack {
            VStack(spacing: 10) {
                SearchTextField(searchQuery: $vm.searchQuery, prompt: $vm.searchPlaceholder)
                
                switch dataType {
                case .network:
                    GamesCollectionView()
                case .library:
                    SavedCollectionView(games: vm.savedGames)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
            .overlay {
                GamesOverlayView(dataType: dataType, filterType: filterType)
            }
        }
        .padding(.bottom, 5)
    }
    
    private var Header: some View {
        VStack(spacing: 0) {
            HStack {
                MultiPicker
                Spacer()
                FiltersButton
                LibraryButton
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .sheet(isPresented: $showSelectionOptions, content: {
            SelectionsView(reference: dataType, selectedSegment: $selectedSegment, vm: $vm)
                .presentationDetents([.fraction(0.65), .large])
        })
    }
    
    private var LibraryButton: some View {
        Button {
            showLibraries = true
        } label: {
            SFImage(name: "tray.full.fill", padding: 10, color: .secondary)
        }
    }
    
    private var FiltersButton: some View {
        Button(action: {
            showSelectionOptions = true
        }, label: {
            SFImage(name: "slider.horizontal.3",
                    padding: 10,
                    color: vm.hasFilters ? appTint : .secondary)
            .overlay {
                switch dataType {
                default:
                    ClearFiltersButton
                }
            }
        })
        .animation(.bouncy, value: vm.hasFilters)
    }
    
    @ViewBuilder
    private var ClearFiltersButton: some View {
        if vm.hasFilters {
            Button(action: {
               // vm.removeFilters(games: savedGames, library: selectedLibrary,  libraries: savedLibraries)
            }, label: {
                SFImage(name: "xmark.circle.fill",
                        opacity: 0,
                        padding: 0,
                        color: vm.hasFilters ? appTint : .clear)
                
            })
            .offset(x: 18, y: -18)
        }
    }
    
    private var MultiPicker: some View {
        Menu {
            CategoryPicker
            
            Divider()
            
            LibraryPicker
            
        } label: {
            HStack(alignment: .center, spacing: 4) {
                HStack(spacing: 8) {
                    SFImage(
                        name: vm.headerImageName,
                        opacity: 0,
                        radius: 0,
                        padding: 0,
                        color: appTint
                    )
                    
                    Text(vm.headerTitle)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                        .shadow(radius: 10)
                }
                
                Image(systemName: "chevron.down")
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
            }
            .hSpacing(.leading)
        }
        .onChange(of: vm.selectedGenres, { oldValue, newValue in
            filterType = .genre
            vm.selectedGenres = newValue
            vm.filterSegment(games: savedGames, libraries: savedLibraries)
        })
        .onChange(of: vm.selectedPlatforms, { oldValue, newValue in
            filterType = .platform
            vm.selectedPlatforms = newValue
            vm.filterSegment(games: savedGames, libraries: savedLibraries)
        })
        .onChange(of: vm.fetchTaskToken.platforms, { oldValue, newValue in
            filterType = .platform
            withAnimation {
                if vm.fetchTaskToken.platforms.isEmpty {
                    vm.fetchTaskToken.platforms = [.database]
                } else {
                    vm.fetchTaskToken.platforms = newValue
                }
            }
            
            Task {
                await vm.refreshTask()
            }
        })
        .onChange(of: vm.fetchTaskToken.genres, { oldValue, newValue in
            filterType = .genre
            withAnimation {
                if vm.fetchTaskToken.genres.isEmpty {
                    vm.fetchTaskToken.genres = []
                } else {
                    vm.fetchTaskToken.genres = newValue
                }
            }
            
            Task {
                await vm.refreshTask()
            }
        })
    }
    
    private var CategoryPicker: some View {
        Menu {
            ForEach(Category.allCases, id: \.id) { category in
                Button {
                    vm.fetchTaskToken.category = category
                    vm.headerTitle = category.title
                    vm.headerImageName = category.systemImage
                    dataType = .network
                    vm.searchPlaceholder = "Search in network"
                } label: {
                    Label(category.title, systemImage: category.systemImage).tag(category)
                }
            }
        } label: {
            Label("Network", systemImage: "globe")
        }
    }
    
    private var LibraryPicker: some View {
        Menu {
            Button {
                vm.headerTitle = "All games"
                vm.headerImageName =  "bookmark"
                vm.searchPlaceholder = "Search in library"
                dataType = .library
                filterType = .library
                
                vm.filterSegment(games: savedGames, libraries: savedLibraries)
            } label: {
                Label("All games", systemImage: "bookmark")
            }
            
            ForEach(savedLibraries, id: \.savingId) { library in
                Button {
                    vm.headerTitle = library.title
                    
                    if let icon = library.icon {
                        vm.headerImageName =  icon
                    }
                    
                    vm.searchPlaceholder = "Search in library"
                    dataType = .library
                    filterType = .library
                    
                    selectedLibrary = library
                    vm.filterSegment(games: savedGames, library: library, libraries: savedLibraries)
                } label: {
                    HStack {
                        if let icon = library.icon {
                            Image(systemName: icon)
                                .imageScale(.medium)
                        }
                        
                        Text(library.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    .tag(library.savingId)
                }
            }
        } label: {
            Label("Libraries", systemImage: "tray.full.fill")
        }
    }
}

