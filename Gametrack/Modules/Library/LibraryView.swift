//
//  LibraryView.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI

struct LibraryView: View {

    @Query(animation: .snappy) var data: [SavedGame]
    
    @Environment(\.modelContext) private var context
    @Environment(Preferences.self) private var preferences: Preferences
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white

    @State private var selectedLibraryType: LibraryType = .all
    @State private var searchQuery = ""
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            VStack {
                Header
                Spacer()
                ViewSwitcher
            }
            .background(.gray.opacity(0.15))
            .onChange(of: searchQuery, { oldValue, newValue in
                isSearching = !newValue.isEmpty
            })
            .onReceive(NotificationCenter.default.publisher(
                for: UIApplication.keyboardWillHideNotification), perform: { _ in
                isSearching = false
            })
        }
    }

    var savedGames: [SavedGame] {
        if selectedLibraryType == .all {
            return data
        } else {
            return data.filter({ $0.libraryType == selectedLibraryType })
        }
    }
    
    var filteredGames: [SavedGame] {
        return savedGames.filter { game in
            if let name = game.game?.name {
                return name.lowercased().contains(searchQuery.lowercased())
            }
            
            return false
        }
    }
    
    private var Header: some View {
        HStack {
            LibraryPicker
            Spacer()
            ViewTypeButton(viewType: $viewType)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private var LibraryPicker: some View {
        Menu {
            Picker("Library", selection: $selectedLibraryType) {
                ForEach(LibraryType.allCases, id: \.id) { library in
                    Text(library.title).tag(library)
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 4) {
                HStack(spacing: 8) {
                    SFImage(name: selectedLibraryType.selectedIconName, opacity: 0, radius: 0, padding: 0, color: appTint)
                    
                    Text(selectedLibraryType.title)
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
                SearchTextField(searchQuery: $searchQuery)
                
                if savedGames.isEmpty {
                    ContentUnavailableView(
                        "No content found in your library",
                        systemImage: "gamecontroller.fill",
                        description: Text(
                            "Please add some games to your library."
                        )
                    )
                } else {
                    SavedCollectionView(games: isSearching ? filteredGames : savedGames, 
                                        viewType: $viewType)
                        .overlay {
                            if isSearching && filteredGames.isEmpty{
                                ContentUnavailableView.search(text: searchQuery)
                            }
                        }
                        
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        .padding(.bottom, 5)
    }
    
    
}
