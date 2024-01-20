//
//  DiscoverView.swift
//  JustGames
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftData
import SwiftUI

struct GamesView: View {
    
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white
    
    @Environment(Preferences.self) private var preferences
    @Environment(NetworkMonitor.self) private var network
    
    @State var vm: GamesViewModel

    @State private var showLibraries = false
    @State private var showAddLibrary = false
    @State private var showSelectionOptions = false
    @State private var selectedSegment: SelectionOption = .genre
    @State private var gameToAddForNewLibrary: Game?
    @State private var receivedLibrary: Library?
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
            .sheet(item: $gameToAddForNewLibrary, content: { game in
                AddLibraryView(game: game)
                    .presentationDetents([.fraction(0.7)])
            })
            .sheet(isPresented: $showSelectionOptions, content: {
                SelectionsView(dataType: vm.dataType, library: selectedLibrary, selectedOption: $selectedSegment, vm: $vm)
                    .presentationDetents([.medium, .large])
            })
            .onReceive(NotificationCenter.default.publisher(for: .newLibraryButtonTapped), perform: { notification in
                if let game = notification.object as? Game {
                    gameToAddForNewLibrary = game
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: .addedToLibrary), perform: { notification in
                if let library = notification.object as? Library {
                    receivedLibrary = library
                }
            })
            .onReceive(didRemoteChange, perform: { _ in
                vm.filterSegment(savedGames: savedGames, library: selectedLibrary)
            })
            .onChange(of: vm.fetchTaskToken.platforms, { oldValue, newValue in
                vm.onChangePlatforms(for: savedGames, in: selectedLibrary, newValue: newValue)
            })
            .onChange(of: vm.fetchTaskToken.genres, { oldValue, newValue in
                vm.onChangeGenres(for: savedGames, in: selectedLibrary, newValue: newValue)
            })
            .onChange(of: vm.searchQuery) { _, newValue in
                vm.filterType = .search
                
                switch vm.dataType {
                case .network:
                    Task {
                        if !newValue.isEmpty {
                            try await Task.sleep(seconds: 0.5)
                            vm.fetchTaskToken.category = .database
                            await vm.refreshTask()
                        } else {
                            await vm.refreshTask()
                            dismissKeyboard()
                        }
                    }
                case .library:
                    vm.filterSegment(savedGames: savedGames, library: selectedLibrary)
                }
            }
        }
    }
    
    private var ViewSwitcher: some View {
        ZStack {
            VStack(spacing: 10) {
                SearchTextField(searchQuery: $vm.searchQuery, prompt: $vm.searchPlaceholder)
                
                switch vm.dataType {
                case .network:
                    GamesCollectionView()
                case .library:
                    SavedCollectionView(games: vm.savedGames)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
            .overlay {
                GamesOverlayView(dataType: vm.dataType, filterType: vm.filterType)
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
                ClearFiltersButton
            }
        })
        .animation(.bouncy, value: vm.hasFilters)
    }
    
    @ViewBuilder
    private var ClearFiltersButton: some View {
        if vm.hasFilters {
            Button(action: {
                vm.removeFilters()
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
    }
    
    private var CategoryPicker: some View {
        Menu {
            ForEach(Category.allCases, id: \.id) { category in
                Button {
                    vm.categorySelected(for: category)
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
                selectedLibrary = nil
                vm.librarySelectionTapped(allSelected: true, in: savedGames)
            } label: {
                Label("All games", systemImage: "bookmark")
            }
            
            ForEach(savedLibraries, id: \.savingId) { library in
                Button {
                    selectedLibrary = library
                    vm.librarySelectionTapped(allSelected: false, for: library, in: savedGames)
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
                }
                .tag(library.savingId)
            }
        } label: {
            Label("Libraries", systemImage: "tray.full.fill")
        }
    }
}

