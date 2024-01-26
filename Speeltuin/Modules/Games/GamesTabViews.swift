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
                FiltersButton
                LibraryButton
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
        } label: {
            SFImage(name: "tray.full.fill", config: .init(padding: 10, color: .secondary))
        }
    }
    
    var FiltersButton: some View {
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
    var ClearFiltersButton: some View {
        if vm.hasFilters {
            Button(action: {
                vm.removeFilters()
                
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(vm.hasFilters ? appTint : .clear)
            })
            .offset(x: 18, y: -18)
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

