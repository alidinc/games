//
//  LibraryView.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI


struct LibraryView: View {

    @State var vm: LibraryViewModel
    @Query(animation: .snappy) var data: [SavedGame]
    
    @Environment(\.modelContext) private var context
    @Environment(Preferences.self) private var preferences: Preferences
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white

    @State private var showSelectionOptions = false
    @State private var selectedSegment: SegmentType = .platform
    
    @State private var showOverlay = false
    @State private var showGenresOverlay = false
    @State private var showPlatformsOverlay = false
    @State private var showLibraryOverlay = false
    
    var didRemoteChange = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: RunLoop.main)

    var body: some View {
        NavigationStack {
            VStack {
                Header
                ViewSwitcher
            }
            .background(.gray.opacity(0.15))
            .onReceive(didRemoteChange, perform: { _ in
                vm.filterSegment(games: data)
                
                DispatchQueue.main.async {
                    showLibraryOverlay = vm.savedGames.isEmpty
                }
            })
            .task {
                vm.filterSegment(games: data)
            }
            .onChange(of: vm.searchQuery, { oldValue, newValue in
                vm.filterSegment(games: data)
                
                DispatchQueue.main.async {
                    showOverlay = vm.savedGames.isEmpty
                }
            })
            .onChange(of: vm.selectedGenres, { oldValue, newValue in
                vm.filterSegment(games: data)
                
                DispatchQueue.main.async {
                    showGenresOverlay = vm.savedGames.isEmpty
                }
            })
            .onChange(of: vm.selectedPlatforms, { oldValue, newValue in
                vm.filterSegment(games: data)
                
                DispatchQueue.main.async {
                    showPlatformsOverlay = vm.savedGames.isEmpty
                }
            })
            .onChange(of: vm.selectedLibraryType, { oldValue, newValue in
                vm.filterSegment(games: data)
                
                DispatchQueue.main.async {
                    showLibraryOverlay = vm.savedGames.isEmpty
                }
            })
        }
    }
   
    
    private var Header: some View {
        VStack(spacing: 0) {
            HStack {
                LibraryPicker
                Spacer()
                ViewTypeButton()
            }
            
            HStack(alignment: .center) {
                SelectedOptionsTitleView(reference: .local, selectedSegment: $selectedSegment) {
                    showSelectionOptions = true
                }
                
                if !vm.selectedGenres.isEmpty || !vm.selectedPlatforms.isEmpty {
                    Button(action: {
                        vm.selectedGenres.removeAll()
                        vm.selectedPlatforms.removeAll()
                    }, label: {
                        Text("Clear")
                            .font(.caption)
                            .padding(6)
                            .background(.secondary, in: .capsule)
                            .padding(6)
                    })
                }
            }
            .frame(maxHeight: 40)
        }
        
        .padding(.horizontal)
        .sheet(isPresented: $showSelectionOptions, content: {
            SelectionsView(reference: .local, selectedSegment: $selectedSegment)
                .presentationDetents([.medium, .large])
        })
    }
    
    private var LibraryPicker: some View {
        Menu {
            Picker("Library", selection: $vm.selectedLibraryType) {
                ForEach(LibraryType.allCases, id: \.id) { library in
                    Text(library.title).tag(library)
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 4) {
                HStack(spacing: 8) {
                    SFImage(name: vm.selectedLibraryType.selectedIconName, opacity: 0, radius: 0, padding: 0, color: appTint)
                    
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
    
    @MainActor
    var ViewSwitcher: some View {
        ZStack {
            VStack(spacing: 10) {
                SearchTextField(searchQuery: $vm.searchQuery)
                
                LibraryCollectionView(games: vm.savedGames, viewType: $viewType)
                    .overlay {
                        Overlay
                    }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    private var Overlay: some View {
        if showLibraryOverlay {
            ContentUnavailableView(
                "No content found for this library.",
                image: "gamecontroller.fill",
                description: Text(
                    "Please add some games from the discover tab."
                )
            )
        } else if showOverlay && !vm.searchQuery.isEmpty {
            ContentUnavailableView.search(text: vm.searchQuery)
        } else if showGenresOverlay || showPlatformsOverlay {
            ContentUnavailableView(
                "No content found for selected filters",
                image: "gamecontroller.fill",
                description: Text(
                    "Please add some games from the discover tab."
                )
            )
        }
    }
}
