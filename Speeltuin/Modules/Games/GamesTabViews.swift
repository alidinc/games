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
            GamesCollectionView(dataManager: dataManager)
                .overlay { GamesOverlayView() }
                .refreshable {
                    await vm.refreshTask()
                }
        case .library:
            SPGamesCollectionView(dataManager: dataManager)
                .overlay { GamesOverlayView() }
        }
    }
    
    var Header: some View {
        VStack {
            HStack(alignment: .bottom) {
                MultiPicker
                Spacer()
                HStack(alignment: .bottom, spacing: 4) {
                    SearchButton
                    FiltersButton
                    if vm.hasFilters {
                        ClearFiltersButton
                    }
                    LibraryButton
                }
            }
            .padding(.horizontal)
            
            if showSearch {
                SearchTextField(
                    searchQuery: $vm.searchQuery,
                    prompt: vm.searchPlaceholder,
                    isFocused: $isTextFieldFocused
                )
                .padding(.horizontal, 10)
            }
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
            SFImage(
                name: "tray.full.fill",
                config: .init(
                    opacity: 0.5,
                    padding: 10,
                    color: .secondary
                )
            )
        }
    }
    
    var FiltersButton: some View {
        Button(action: {
            showSelectionOptions = true
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        },
               label: {
            SFImage(
                name: "slider.horizontal.3",
                config: .init(
                    opacity: 0.5,
                    padding: 10,
                    color: vm.hasFilters ? appTint : .secondary
                )
            )
        })
        .animation(.bouncy, value: vm.hasFilters)
    }
    
    var SearchButton: some View {
        Button {
            withAnimation(.bouncy) {
                showSearch.toggle()
            }
            
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        } label: {
            SFImage(
                name: "magnifyingglass",
                config: .init(
                    opacity: 0.5,
                    padding: 10,
                    color: showSearch ? appTint : .secondary
                )
            )
        }
        .transition(.move(edge: .top))
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
                SFImage(
                    name: "slider.horizontal.2.gobackward",
                    config: .init(
                        opacity: 0.5,
                        padding: 10,
                        color: vm.hasFilters ? appTint : .clear
                    )
                )
            })
        }
    }
    
    var MultiPicker: some View {
        Menu {
            CategoryPicker
            Divider()
            LibraryPicker
            
        } label: {
            PickerHeaderView(title: vm.headerTitle)
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
                    Text(category.title)
                }
                .tag(category)
            }
        } label: {
            Text("Internet")
        }
    }
    
    var LibraryPicker: some View {
        Menu {
            Button {
                vm.selectedLibrary = nil
                vm.librarySelectionTapped(allSelected: true, in: savedGames)
            } label: {
                Label("All saved games", systemImage: "bookmark.fill")
            }
            
            ForEach(savedLibraries, id: \.persistentModelID) { library in
                Button {
                    vm.selectedLibrary = library
                    vm.librarySelectionTapped(allSelected: false, for: library, in: savedGames)
                } label: {
                    Text(library.title)
                }
                .tag(library.persistentModelID)
            }
        } label: {
            Text("Libraries")
        }
    }
}

