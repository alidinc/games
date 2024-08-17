//
//  GamesTab.swift
//  Speeltuin
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftData
import SwiftUI
import Combine


enum ContentType: String, CaseIterable, Identifiable {
    case games
    case news
    case library

    var id: Self { return self }

    var title: String {
        return self.rawValue.capitalized
    }

    var imageName: String {
        switch self {
        case .games:
            return "gamecontroller.fill"
        case .news:
            return "newspaper.fill"
        case .library:
            return "tray.full.fill"
        }
    }
}

struct MainView: View {

    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("viewType") var viewType: ViewType = .grid
    @AppStorage("appTint") var appTint: Color = .blue

    @Environment(\.colorScheme) private var scheme
    @Query(animation: .easeInOut) var savedGames: [SavedGame]
    @Query(animation: .easeInOut) var libraries: [Library]

    @State var newsVM = NewsViewModel()
    @State var vm = GamesViewModel()
    @State var isTextFieldFocused: Bool = false
    @State var showSearch = false
    @State var contentType: ContentType = .games

    @State private var libraryToDelete: Library?
    @State private var libraryToEdit: Library?
    @State private var showDeleteAlert = false

    private var gradientColors: [Color] {
        let label = scheme == .dark ? Color.black : Color.white.opacity(0.15)
        return [label, appTint.opacity(0.45)]
    }

    var body: some View {
        NavigationStack {
            VStack {
                CountView
                Header
                ContentTypeView
            }
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .toolbarBackground(.hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom))
            .onChange(of: vm.fetchTaskToken.platforms, { oldValue, newValue in
                vm.onChangePlatforms(for: savedGames, newValue: newValue)
            })
            .onChange(of: vm.fetchTaskToken.genres, { oldValue, newValue in
                vm.onChangeGenres(for: savedGames, newValue: newValue)
            })
            .onChange(of: vm.searchQuery) { _, newValue in
                vm.onChangeQuery(for: savedGames, newValue: newValue)
            }
            .onChange(of: showSearch) { oldValue, newValue in
                isTextFieldFocused = newValue
            }
            .task(id: vm.fetchTaskToken) { await vm.fetchGames() }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MoreTab()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
    }
}

extension MainView {

    var CountView: some View {
        VStack(spacing: 6) {
            Text(self.countOfSavedGames, format: .number)
                .font(.system(size: 80))
                .fontWeight(.semibold)
                .contentTransition(.numericText())

            LibrariesMenu
        }
        .frame(height: UIScreen.main.bounds.height / 5)
    }

    // Computed property to get the count of saved games based on the content type and selected library
    private var countOfSavedGames: Int {
        if let libraryToEdit = libraryToEdit, contentType == .library {
            return libraryToEdit.savedGames?.count ?? 0
        } else {
            return libraries.reduce(0) { $0 + ($1.savedGames?.count ?? 0) }
        }
    }

    @ViewBuilder
    var ContentTypeView: some View {
        switch self.contentType {
        case .games:
            GamesCollectionView()
                .overlay(content: { GamesOverlayView() })
                .refreshable {
                    await vm.refreshTask()
                }
        case .news:
            NewsTab(vm: newsVM)
        case .library:
            LibraryView()
        }
    }

    var LibrariesMenu: some View {
        Menu {
            ForEach(libraries) { library in
                Button {
                    self.libraryToEdit = library
                    self.contentType = .library
                } label: {
                    HStack {
                        Text(library.title)
                            .font(.body)
                            .fontWeight(.regular)

                        if let savedGames = library.savedGames {
                            Text(savedGames.count, format: .number)
                                .font(.body)
                                .fontWeight(.medium)
                                .padding(.trailing)
                        }
                    }
                }
            }

            Divider()

            Button {
                self.libraryToEdit = nil
                self.contentType = .library
            } label: {
                HStack {
                    Text("Show All Games")
                    Image(systemName: "tray.full.fill")
                }
            }

        } label: {
            if let library = libraryToEdit {
                VStack(alignment: .center, spacing: 2) {
                    Text(library.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(library.date, format: .dateTime.year().month(.wide).day())
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            } else {
                VStack(alignment: .center, spacing: 2) {
                    Text("All saved games")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(Date.now, format: .dateTime.year().month(.wide).day())
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
        }
    }

    private func deleteLibrary(at offsets: IndexSet) {
        for index in offsets {
            let library = libraries[index]
            self.libraryToDelete = library
            self.showDeleteAlert = true
        }
    }


    @ViewBuilder
    func LibraryView() -> some View {
        if let libraryToEdit = libraryToEdit, let savedGames = libraryToEdit.savedGames {
            List {
                ForEach(savedGames) { data in
                    ListItemView(game: data.game)
                        .navigationLink({
                            GameDetailView(savedGame: data)
                        })
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .padding(.vertical, 12)
        } else {
            List {
                ForEach(libraries.flatMap { $0.savedGames ?? [] }) { data in
                    ListItemView(game: data.game)
                        .navigationLink({
                            GameDetailView(savedGame: data)
                        })
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .padding(.vertical, 12)
        }
    }
}

