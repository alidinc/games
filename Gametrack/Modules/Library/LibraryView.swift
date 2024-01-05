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

    var body: some View {
        NavigationStack {
            VStack {
                Header
                Spacer()
                ViewSwitcher
            }
            .background(.gray.opacity(0.15))
            .task {
                vm.filterSegment(games: data)
            }
            .onChange(of: vm.searchQuery, { oldValue, newValue in
                vm.filterSegment(games: data)
            })
            .onChange(of: vm.selectedGenres, { oldValue, newValue in
                vm.filterSegment(games: data)
            })
            .onChange(of: vm.selectedPlatforms, { oldValue, newValue in
                vm.filterSegment(games: data)
            })
            .onChange(of: vm.selectedLibraryType, { oldValue, newValue in
                vm.filterSegment(games: data)
            })
        }
    }
   
    
    private var Header: some View {
        VStack {
            HStack {
                LibraryPicker
                Spacer()
                ViewTypeButton(viewType: $viewType)
            }
            .padding(.vertical, 10)
            
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
                        .font(.system(size: 26, weight: .semibold))
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
                
                SavedCollectionView(games: vm.savedGames, viewType: $viewType)
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        .padding(.bottom, 5)
    }
}
