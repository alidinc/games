//
//  GamesTabViews.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI

extension GamesTab {
    @ViewBuilder
    var ViewSwitcher: some View {
        switch vm.dataType {
        case .network:
            GamesNetworkView()
                .overlay { GamesOverlayView() }
        case .library:
            GamesLocalView()
                .overlay { GamesOverlayView() }
        }
    }
    
    var Header: some View {
        VStack {
            HStack {
                MultiPicker
                Spacer()
                HStack(spacing: 4) {
                    FiltersButton
                    if vm.hasFilters {
                        ClearFiltersButton
                    }
                    LibraryButton
                }
            }
            .padding(.horizontal, 20)
            
            SearchTextField(searchQuery: $vm.searchQuery,
                            prompt: vm.searchPlaceholder)
            .padding(.horizontal, 10)
            
        }
        .padding(.top)
    }
    
    var LibraryButton: some View {
        Button {
            showLibraries = true
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        } label: {
            SFImage(name: "tray.full.fill", config: .init(opacity: 0.5, padding: 10, color: .secondary))
        }
    }
    
    var FiltersButton: some View {
        Button(action: {
            showSelectionOptions = true
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        }, label: {
            SFImage(name: "slider.horizontal.3",
                    config: .init(
                        opacity: 0.5,
                        padding: 10,
                        color: vm.hasFilters ? appTint : .secondary
                    ))
        })
        .animation(.bouncy, value: vm.hasFilters)
    }
    
    @ViewBuilder
    var ClearFiltersButton: some View {
        if vm.hasFilters {
            Button(action: {
                vm.removeFilters()
                
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
            }, label: {
                SFImage(name: "slider.horizontal.2.gobackward",
                        config: .init(
                            opacity: 0.5,
                            padding: 10,
                            color: vm.hasFilters ? appTint : .clear
                        ))
            })
        }
    }
    
    var MultiPicker: some View {
        Menu {
            CategoryPicker
            Divider()
            LibraryPicker
            
        } label: {
            PickerHeaderView(title: vm.headerTitle, imageName: vm.headerImageName)
        }
    }
    
    var CategoryPicker: some View {
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
    
    var LibraryPicker: some View {
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

