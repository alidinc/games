//
//  DiscoverView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftData
import SwiftUI

struct GamesView: View {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white
    
    @Environment(Admin.self) private var preferences
    
    @State var vm: GamesViewModel
    
    @State private var showLibraries = false
    @State private var showSelectionOptions = false
    @State private var gameToAddForNewLibrary: Game?
    @State private var receivedLibrary: Library?
    
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
            .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.5), trigger: hapticsEnabled && (showLibraries || showSelectionOptions))
            .sheet(isPresented: $showLibraries, content: {
                LibraryView()
                    .presentationDetents([.medium])
            })
            .sheet(item: $gameToAddForNewLibrary, content: { game in
                AddLibraryView(game: game)
                    .presentationDetents([.fraction(0.7)])
            })
            .sheet(isPresented: $showSelectionOptions, content: {
                SelectionsView()
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
                vm.filterSegment(savedGames: savedGames)
            })
            .onChange(of: vm.fetchTaskToken.platforms, { oldValue, newValue in
                vm.onChangePlatforms(for: savedGames, newValue: newValue)
            })
            .onChange(of: vm.fetchTaskToken.genres, { oldValue, newValue in
                vm.onChangeGenres(for: savedGames, newValue: newValue)
            })
            .onChange(of: vm.searchQuery) { _, newValue in
                vm.onChangeQuery(for: savedGames, newValue: newValue)
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
            SFImage(name: "tray.full.fill", config: .init(padding: 10, color: .secondary))
        }
    }
    
    private var FiltersButton: some View {
        Button(action: {
            showSelectionOptions = true
        }, label: {
            SFImage(name: "slider.horizontal.3",
                    config: .init(
                        padding: 10,
                        color: vm.hasFilters ? appTint : .secondary
                    ))
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
                
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
            }, label: {
                SFImage(name: "xmark.circle.fill",
                        config: .init(
                            opacity: 0,
                            padding: 0,
                            color: vm.hasFilters ? appTint : .clear
                        ))
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
            PickerHeaderView(title: vm.headerTitle, imageName: vm.headerImageName)
        }
    }
    
    private var CategoryPicker: some View {
        Menu {
            ForEach(Category.allCases, id: \.id) { category in
                Button {
                    vm.categorySelected(for: category)
                    if hapticsEnabled {
                        HapticsManager.shared.vibrateForSelection()
                    }
                } label: {
                    Label(category.title, systemImage: category.systemImage).tag(category)
                }
            }
        } label: {
            Label("Internet", systemImage: "sparkle.magnifyingglass")
        }
    }
    
    private var LibraryPicker: some View {
        Menu {
            Button {
                vm.selectedLibrary = nil
                vm.librarySelectionTapped(allSelected: true, in: savedGames)
                
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
            } label: {
                Label("All games", systemImage: "bookmark.fill")
            }
            
            ForEach(savedLibraries, id: \.savingId) { library in
                Button {
                    vm.selectedLibrary = library
                    vm.librarySelectionTapped(allSelected: false, for: library, in: savedGames)
                    
                    if hapticsEnabled {
                        HapticsManager.shared.vibrateForSelection()
                    }
                } label: {
                    Label(library.title, systemImage: library.icon)
                }
                .tag(library.savingId)
            }
        } label: {
            Label("Libraries", systemImage: "tray.full.fill")
        }
    }
}

